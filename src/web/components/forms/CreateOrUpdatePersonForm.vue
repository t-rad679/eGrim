<script setup lang="ts">
import { ApolloError } from "@apollo/client/core"
import { Tag, TagToObjectRelation } from "@client-types"
import { useMutation, useQuery } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { computed, ref, watch } from "vue"

import { createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne } from "@/api/globalApiHelper.js"
import { createUpsertPersonMutation, doUpsertPerson } from "@/api/personApi.js"
import {
    createTagToObjectRelationCreateOrConnectInputForMutations,
    createTagToObjectRelationWhereUniqueInputForMutations,
} from "@/api/tagToObjectRelationApi.js"
import { createUserWhereUniqueInputForMutations } from "@/api/userApi.js"
import TagInput from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore.js"
import { DeepPartial } from "@/utils/DeepPartial.js"
import { createFieldRequiredRule } from "@/utils/validationUtils.js"

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
const printErrorFunction = (error: ApolloError) => {
    console.log(error)
    errorMessages.value.push(error.message)
    success.value = false
}

const nameRules = [createFieldRequiredRule("Name")]

const { mutate, onDone, onError } = createUpsertPersonMutation()

onDone(() => {
    success.value = true
})
onError(printErrorFunction)

const personQueryText = gql`
        query person($where: PersonWhereUniqueInput!) {
            person(where: $where) {
                id
                name
                description
                tags {
                    tag {
                        id
                        name
                    }
                }
            }
        }
    `
const { result, onError: personQueryOnError } = useQuery(personQueryText, {
    where: {
        userId_name: {
            name: props.personName,
            userId: userStore.user.id,
        },
    },
})

personQueryOnError(printErrorFunction)

let oldTags: DeepPartial<Tag>[] = []
const newlySelectedTags = computed(
    () => tags.value.filter((tag) => !oldTags.map((tag) => tag.name ?? "").includes(tag)),
)
const newlyRemovedTags = computed(() => oldTags.filter((tag) => !tags.value.includes(tag.name ?? "")))
watch(result, (newResult) => {
    if (newResult.person) {
        name.value = newResult.person.name
        personId = newResult.person.id
        description.value = newResult.person.description
        tags.value = newResult.person.tags?.map((tag: DeepPartial<TagToObjectRelation>) => tag?.tag?.name) ?? []
        oldTags = newResult.person.tags?.map((tag: DeepPartial<TagToObjectRelation>) => tag?.tag) ?? []
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
        newlySelectedTags.value,
        newlyRemovedTags.value.map((tag) => tag.id ?? ""),
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