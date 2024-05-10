<script setup lang="ts">
import { User } from "@client-types"
import { useLazyQuery, useMutation, useQuery } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

import { DeepPartial } from "@/utils/DeepPartial"

const printErrorFunction = (error) => {
    errorMessages.value.push(error.message)
}
const name = ref("")
const tags = ref([] as string[])
const errorMessages = ref([] as string[])
const success = ref(false)

const nameRules = [
    (value: string) => (value ? true : "Name is required"),
]

const createPersonMutationText = gql`
        mutation createPersonMutationText($input: PersonCreateInput!) {
            createOnePerson(data: $input) {
                id
            }
        }
`

const {
    mutate: createMutate,
    onDone: createOnDone,
    onError: createOnError,
} = useMutation(createPersonMutationText)

const updatePersonMutationText = gql`
        mutation createOrUpdatePersonMutationText($input: CreateOrUpdatePersonInput!, $where: PersonWhereUniqueInput!) {
            updateOnePerson(data: $input, where: $where) {
                id
            }
        }
`

createOnDone(() => {
    success.value = true
})
createOnError(printErrorFunction)

const {
    mutate: updateMutate,
    onDone: updateOnDone,
    onError: updateOnError,
} = useMutation(updatePersonMutationText)

updateOnError(printErrorFunction)

function onSubmit() {
    async function createOrUpdatePerson(
        name: string,
        tags: string[],
    ) {
        await createMutate({
            input: {
                name,
            },
        })
    }
    // TODO: DO NOT SUBMIT WITHOUT THIS
    createOrUpdatePerson(
        name.value,
        tags.value,
    )
}

</script>

<template>
  <v-form
    validate-on="blur"
    clas="w-50"
    @submit.prevent="onSubmit"
  >
    <!-- TODO before submit: make this work for creating or updating -->
    <h2>Create Person</h2>
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="The name you associate with this person most strongly"
    />
    <v-btn
      type="submit"
    >
      Create Person
    </v-btn>
  </v-form>
  <p v-if="errorMessages">
    {{ errorMessages }}
  </p>
  <p v-if="success">
    Successfully executed create query
  </p>
</template>

<style scoped>

</style>