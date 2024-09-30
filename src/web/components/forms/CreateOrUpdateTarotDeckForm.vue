<script setup lang="ts">

import {
    Tag,
    TagToObjectRelation,
    TarotSuitAlias,
} from "@client-types"
import {
    computed,
    ref,
    watch,
} from "vue"
import { VForm } from "vuetify/components" // Ensure MDI icons are imported

import {
    createUpsertTarotDeckMutation,
    doUpsertTarotDeck,
} from "@/api/tarotDeck/mutations/upsertTarotDeck.js"
import { doTarotDeckQuery } from "@/api/tarotDeck/queries/fetchTarotDeck.js"
import TagInput from "@/components/inputs/TagInput.vue"
import TarotSuitAliasInput from "@/components/inputs/TarotSuitAliasInput.vue"
import { useUserStore } from "@/stores/UserStore.js"
import { DeepPartial } from "@/utils/DeepPartial.js"
import { createFieldRequiredRule } from "@/utils/validationUtils.js"
import "vuetify/styles"
import "@mdi/font/css/materialdesignicons.css"

const props = defineProps({
    deckName: {
        type: String,
        default: "",
        required: false,
    },
})

const name = ref("")
const notes = ref("")
const tags = ref([] as string[])
const suitAliases = ref([] as DeepPartial<TarotSuitAlias>[])
const success = ref(false)
const isFormValid = ref(false)

const suitNames = computed(() => suitAliases.value.map((alias) => alias.suit?.name ?? ""))
const isFormChanged = computed(() => {
    return (
        name.value !== originalFormState.name ||
            notes.value !== originalFormState.notes ||
            JSON.stringify(tags.value) !== JSON.stringify(originalFormState.tags) ||
            JSON.stringify(suitAliases.value) !== JSON.stringify(originalFormState.suitAliases)
    )
})

const userStore = useUserStore()

const nameRules = [createFieldRequiredRule("Name")]

let oldTags: DeepPartial<Tag>[] = []
let oldSuitAliases: DeepPartial<TarotSuitAlias>[] = []
let suitAliasesToDelete: DeepPartial<TarotSuitAlias>[] = []
let tarotDeckId = ""
let originalFormState = {
    name: "",
    notes: "",
    tags: [] as string[],
    suitAliases: [] as DeepPartial<TarotSuitAlias>[],
}

const { result, onError: tarotDeckQueryOnError } = doTarotDeckQuery(props.deckName, userStore.user.id)

watch(result, (newResult) => {
    if (newResult?.tarotDeck) {
        name.value = newResult.tarotDeck.name
        tarotDeckId = newResult.tarotDeck.id
        notes.value = newResult.tarotDeck.notes ?? ""
        tags.value = newResult.tarotDeck.tags.map((tag: TagToObjectRelation) => tag.tag.name) ?? []
        oldTags = newResult.tarotDeck.tags.map((tag: TagToObjectRelation) => tag.tag) ?? []
        oldSuitAliases = newResult.tarotDeck.suitAliases ?? []
        suitAliases.value = [...oldSuitAliases]  // Clone the array to avoid reactivity issues
        originalFormState = {
            name: newResult.tarotDeck.name,
            notes: newResult.tarotDeck.notes ?? "",
            tags: newResult.tarotDeck.tags.map((tag: TagToObjectRelation) => tag.tag.name) ?? [],
            suitAliases: newResult.tarotDeck.suitAliases ?? [],
        }
    }
})

tarotDeckQueryOnError((error) => {
    console.error(error)
    success.value = false
})

const {
    mutate,
    onDone,
    onError: upsertTarotDeckOnError,
} = createUpsertTarotDeckMutation()

onDone(() => {
    success.value = true
})

upsertTarotDeckOnError((error) => {
    console.error(error)
    success.value = false
})

function addSuitAlias() {
    suitAliases.value = suitAliases.value.concat({
        suit: {
            name: "",
        },
        name: "",
    })
}

function removeSuitAlias(index: number) {
    const removedAlias = suitAliases.value[index]
    suitAliases.value.splice(index, 1)
    if (oldSuitAliases.find((alias) => alias.suit?.name === removedAlias.suit?.name)) {
        suitAliasesToDelete.push(removedAlias)
    }
}

function onSubmit() {
    doUpsertTarotDeck(
        mutate,
        name.value,
        userStore.user.username,
        userStore.user.id,
        notes.value,
        [], // TODO: Figure this out
        suitAliases.value.filter((alias) => (
            !oldSuitAliases.map((alias) => alias.suit?.name ?? "").includes(alias.suit?.name ?? "")
        )),
        suitAliasesToDelete,
        tags.value.filter((tag) => !oldTags.map((tag) => tag.name ?? "").includes(tag)),
        oldTags.filter((tag) => !tags.value.includes(tag.name ?? "")).map((tag) => tag.id ?? ""),
        tarotDeckId,
        props.deckName,
    )
}
</script>

<template>
  <v-form
    v-model="isFormValid"
    validate-on="input"
    class="w-75"
    @submit.prevent="onSubmit"
  >
    <h2>{{ props.deckName ? "Update" : "Create" }} Tarot Deck</h2>
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="Name"
      class="required"
    />
    <v-textarea
      v-model="notes"
      label="Notes"
      rows="5"
      outlined
    />
    <TagInput v-model="tags" />
    <h3>Suit Aliases</h3>
    If your deck uses different names for the traditional suits, you can add those aliases here.
    <div />
    <v-list>
      <v-list-item
        v-for="(suitAlias, index) in suitAliases"
        :key="suitAlias?.suit?.name || index"
      >
        <TarotSuitAliasInput
          v-model="suitAliases[index]"
          :index="index"
          :already-used-suits="suitNames"
          @remove="removeSuitAlias"
        />
      </v-list-item>
    </v-list>
    <v-btn
      v-if="suitAliases.length < 4"
      icon="true"
      @click="addSuitAlias"
    >
      <v-icon>mdi-plus</v-icon>
    </v-btn>
    <div />
    <v-btn
      type="submit"
      :disabled="!isFormValid || !isFormChanged"
    >
      {{ props.deckName ? "Save" : "Create" }}
    </v-btn>
    {{ success ? "Success!" : "" }}
    <v-alert
      v-if="!isFormValid"
      icon="$error"
      color="error"
      theme="dark"
      variant="tonal"
    >
      Please fill out all required fields.
    </v-alert>
    <v-alert
      v-if="!isFormChanged"
      icon="$warning"
      color="warning"
      theme="dark"
      variant="tonal"
    >
      No changes made.
    </v-alert>
  </v-form>
</template>
