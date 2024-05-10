<script setup lang="ts">
import { User } from "@client-types"
import { useLazyQuery, useMutation, useQuery } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"
import { computed } from "vue-demi"

import { DeepPartial } from "@/utils/DeepPartial"

const printErrorFunction = (error) => {
    errorMessages.value.push(error.message)
}
const name = ref("")
const tags = ref([] as string[])
const username = ref("")
const errorMessages = ref([] as string[])
const success = ref(false)

const nameRules = [
    (value: string) => (value ? true : "Name is required"),
]

const allUsernames = computed(() => {
    return usersResult?.value?.users?.map((userObj: DeepPartial<User>) => userObj.username)
})

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

const usersQueryText = gql`
        query users {
            users {
                username
                personId
            }
        }
`

const {
    result: usersResult,
    onError: usersOnError,
} = useQuery(usersQueryText)

usersOnError(printErrorFunction)

function onSubmit() {
    async function createOrUpdatePerson(
        name: string,
        tags: string[],
        username?: string,
    ) {
        if(usersResult.value.personId) {
            // TODO: Show a popup
            errorMessages.value.push("This User is already associated with a person")
            return
        }
        await createMutate({
            input: {
                name,
                user: username ? {
                    connect: {
                        username,
                    },
                } : undefined,
            },
        })
    }
    // TODO: DO NOT SUBMIT WITHOUT THIS
    createOrUpdatePerson(
        name.value,
        tags.value,
        username.value ?? undefined,
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
    <v-autocomplete
      v-model="username"
      :items="allUsernames"
      label="If this person is an eGrim user, you can associate them with their eGrim account"
    />
    <v-btn
      type="submit"
    >
      Create Person
    </v-btn>
  </v-form>
  {{ usersResult }}
  <p v-if="errorMessages">
    {{ errorMessages }}
  </p>
  <p v-if="success">
    Successfully executed create query
  </p>
</template>

<style scoped>

</style>