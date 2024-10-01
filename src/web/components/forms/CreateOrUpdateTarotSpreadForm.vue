<script setup lang="ts">

import {
    Tag,
    TagToObjectRelation,
    TarotPosition,
} from "@client-types"
import {
    computed,
    ref,
    watch,
} from "vue"

import {
    createUpsertTarotSpreadMutation,
    doUpsertTarotSpread,
} from "@/api/tarotSpread/mutations/upsertTarotSpread.js"
import { doTarotSpreadQuery } from "@/api/tarotSpread/queries/fetchTarotSpread.js"
import GenericForm from "@/components/forms/GenericForm.vue"
import TagInput from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore.js"
import { DeepPartial } from "@/utils/DeepPartial.js"
import { createFieldRequiredRule } from "@/utils/validationUtils.js"

const { spreadName = "" } = defineProps<{ spreadName?: string }>()

const userStore = useUserStore()

const name = ref("")
const description = ref("")
const tags = ref([] as string[])
const positions = ref([] as DeepPartial<TarotPosition>[])
const success = ref(false)
const isFormValid = ref(false)

const isFormChanged = computed(() => {
    return (
        name.value !== originalFormState.name ||
            description.value !== originalFormState.description ||
            JSON.stringify(tags.value) !== JSON.stringify(originalFormState.tags) ||
            JSON.stringify(positions.value) !== JSON.stringify(originalFormState.positions)
    )
})

let oldTags: DeepPartial<Tag>[] = []
let spreadId = ""
let originalFormState = {
    name: "",
    description: "",
    tags: [] as string[],
    positions: [] as DeepPartial<TarotPosition>[],
}

const { result, onError: tarotSpreadQueryOnError } = doTarotSpreadQuery(spreadName, userStore.user.id)

watch(result, (newResult) => {
    if(newResult?.tarotSpread) {
        name.value = newResult.tarotSpread.name
        spreadId = newResult.tarotSpread.id
        description.value = newResult.tarotSpread.description ?? ""
        tags.value = newResult.tarotSpread.tags.map((tag: TagToObjectRelation) => tag.tag.name) ?? []
        oldTags = newResult.tarotSpread.tags.map((tag: TagToObjectRelation) => tag.tag) ?? []
        positions.value = newResult.tarotSpread.positions.map((position) => ({ ...position }))
        originalFormState = {
            name: newResult.tarotSpread.name,
            description: newResult.tarotSpread.description ?? "",
            tags: [...tags.value],
            positions: positions.value.map((position) => ({ ...position })),
        }
    }
})

tarotSpreadQueryOnError((error) => {
    console.error(error)
})

const {
    mutate,
    onDone,
    onError: upsertTarotSpreadOnError,
} = createUpsertTarotSpreadMutation()

onDone((_) => {
    success.value = true
})

upsertTarotSpreadOnError(error => {
    console.error(error)
    success.value = false
})

function addPosition() {
    positions.value = positions.value.concat({
        number: positions.value.length + 1,
        description: "",
    })
}

function removePosition(index: number) {
    positions.value = [
        ...positions.value.slice(0, index),
        ...positions.value.slice(index + 1).map((position) => {
            return {
                number: position.number! - 1,
                ...position,
            }
        }),
    ]
}

function movePositionUp(index: number) {
    if(index === 0) {
        return
    }
    const temp = positions.value[index - 1]
    positions.value[index - 1] = positions.value[index]
    positions.value[index - 1].number = index // number is 1-indexed, so it should be one greater than the index
    positions.value[index] = temp
    positions.value[index].number = index + 1
}

function movePositionDown(index: number) {
    if(index === positions.value.length - 1) {
        return
    }
    const temp = positions.value[index + 1]
    positions.value[index + 1] = positions.value[index]
    positions.value[index + 1].number = index + 2 // number is 1-indexed, so it should be one greater than the index
    positions.value[index] = temp
    positions.value[index].number = index + 1
}

function validatePositions(): string {
    return positions.value.length > 0 ? "" : "At least one position is required"
}

function onSubmit() {
    doUpsertTarotSpread(
        mutate,
        name.value,
        userStore.user.username,
        userStore.user.id,
        description.value,
        positions.value,
        tags.value.filter((tag) => !oldTags.map((tag) => tag.name ?? "").includes(tag)),
        oldTags.filter((tag) => !tags.value.includes(tag.name ?? "")).map((tag) => tag.id ?? ""),
        spreadId,
        spreadName,
    )
}
</script>

<template>
  <GenericForm
    v-model="isFormValid"
    :submit-fn="onSubmit"
    :is-update="!!spreadName"
    :is-form-changed="isFormChanged"
    :custom-invalid-message="validatePositions()"
  >
    <h2>{{ spreadName ? "Update" : "Create" }} Tarot Spread</h2>
    <v-text-field
      v-model="name"
      label="Name"
      :rules="[createFieldRequiredRule('Name')]"
      class="required"
    />
    <v-textarea
      v-model="description"
      label="Spread Description"
    />
    <TagInput v-model="tags" />
    <h3>
      Positions
      <span>
        <v-icon
          color="grey-lighten-1"
          size="small"
        >mdi-information</v-icon>
        <v-tooltip
          v-if="spreadName"
          activator="parent"
        >
          <!-- TODO: Determine whether we should support rearranging. Definitely don't support removing or adding -->
          Adding, removing, and rearranging positions are disabled for updating existing spreads.
        </v-tooltip>
      </span>
    </h3>
    <div />
    <v-list>
      <v-list-item
        v-for="(position, index) in positions"
        :key="position?.number || index"
      >
        <v-list-item-title><h4>{{ position.number }}</h4></v-list-item-title>
        <v-text-field
          v-model="positions[index].description"
          label="Position Description"
          outlined
          :rules="[createFieldRequiredRule('Description')]"
          class="required"
        />
        <v-list-item-action v-if="!spreadName">
          <v-btn
            v-if="index > 0"
            icon="true"
            @click="movePositionUp(index)"
          >
            <v-icon>mdi-arrow-up</v-icon>
          </v-btn>
          <v-btn
            v-if="index < positions.length - 1"
            icon="true"
            @click="movePositionDown(index)"
          >
            <v-icon>mdi-arrow-down</v-icon>
          </v-btn>
          <v-btn
            v-if="!spreadName"
            icon="true"
            @click="removePosition(index)"
          >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </v-list-item-action>
      </v-list-item>
    </v-list>
    <v-btn
      v-if="!spreadName"
      icon="true"
      @click="addPosition"
    >
      <v-icon>mdi-plus</v-icon>
    </v-btn>
  </GenericForm>
  {{ success ? "Success!" : "" }}
</template>

<style scoped>

</style>
