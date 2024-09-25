<script setup lang="ts">
import { ApolloError } from "@apollo/client/core"
import {
    Tag,
    TagToObjectRelation,
} from "@client-types"
import {
    ref,
    watch,
} from "vue"

import {
    createUpsertPersonMutation,
    doUpsertPerson,
} from "@/api/person/mutations/upsertPerson.js"
import { doPersonQuery } from "@/api/person/queries/fetchPerson.js"
import TagInput from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore"
import { DeepPartial } from "@/utils/DeepPartial"
import { createFieldRequiredRule } from "@/utils/validationUtils"

const props = defineProps({
    personName: {
        type: String,
        default: "",
        required: false,
    },
})

const userStore = useUserStore()

const name = ref("")
const description = ref("")
const tags = ref([] as string[])
const errorMessages = ref([] as string[])
const success = ref(false)

let personId = ""
let oldTags: DeepPartial<Tag>[] = []

const nameRules = [createFieldRequiredRule("Name")]
const printErrorFunction = (error: ApolloError) => {
    console.log(error)
    errorMessages.value.push(error.message)
    success.value = false

}

const { mutate, onDone, onError: upsertPersonOnError } = createUpsertPersonMutation()
onDone(() => {
    success.value = true
})
upsertPersonOnError(printErrorFunction)

const { result, onError: personQueryOnError } = doPersonQuery(props.personName, userStore.user.id)
personQueryOnError(printErrorFunction)

watch(result, (newResult) => {
    if (newResult?.person) {
        name.value = newResult.person.name
        personId = newResult.person.id
        description.value = newResult.person.description ?? ""
        tags.value = newResult.person.tags?.map((tag: TagToObjectRelation) => tag.tag.name) ?? []
        oldTags = newResult.person.tags?.map((tag: TagToObjectRelation) => tag.tag) ?? []
    } else {
        console.log("No person found")
    }
})

function onSubmit() {
    doUpsertPerson(
        mutate,
        name.value,
        description.value,
        userStore.user.username,
        userStore.user.id,
        tags.value.filter((tag) => !oldTags.map((tag) => tag.name ?? "").includes(tag)),
        oldTags.filter((tag) => !tags.value.includes(tag.name ?? "")).map((tag) => tag.id ?? ""),
        personId,
        props.personName,
    )
}

</script>

<template>
  <v-form
    validate-on="blur"
    clas="w-50"
    @submit.prevent="onSubmit"
  >
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="The name you associate with this person most strongly"
      class="required"
    />
    <v-text-field
      v-model="description"
      label="What is this person like?"
    />
    <TagInput v-model="tags" />
    <v-btn
      type="submit"
    >
      {{ props.personName ? "Update" : "Create" }} Person
    </v-btn>
  </v-form>
  <p v-if="errorMessages">
    {{ errorMessages }}
  </p>
  <p v-if="success">
    Successfully executed {{ props.personName ? "update" : "create" }} query
  </p>
</template>

<style scoped>

</style>
