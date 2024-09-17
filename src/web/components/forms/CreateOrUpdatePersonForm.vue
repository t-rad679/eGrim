<script setup lang="ts">
import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

import { createFieldRequiredRule } from "@/utils/validationUtils.js"

const props = defineProps({
    personName: {
        type: String,
        default: "",
        required: false,
    },
})

const printErrorFunction = (error) => {
    errorMessages.value.push(error.message)
}
const name = ref("")
const tags = ref([] as string[])
const errorMessages = ref([] as string[])
const success = ref(false)

const nameRules = [createFieldRequiredRule("Name")]

const createPersonMutationText = gql`
        mutation createPersonMutation($input: PersonCreateInput!) {
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
        mutation updatePersonMutation($input: PersonUpdateInput!, $where: PersonWhereUniqueInput!) {
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

updateOnDone(() => {
    success.value = true
})
updateOnError(printErrorFunction)

function onSubmit() {
    async function createOrUpdatePerson(
        name: string,
        tags: string[],
    ) {
        if(!props.personName) {
            await createMutate({
                input: {
                    name,
                    tags,
                },
            })
        } else {
            await updateMutate({
                input: {
                    name: { set: name }, // This may change when we add actual tags
                    tags,
                },
                where: {
                    name: props.personName,
                },
            })
        }
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
    <h2>{{ props.personName ? "Update" : "Create" }} Person</h2>
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="The name you associate with this person most strongly"
      class="required"
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
    Successfully executed {{ props.personName ? "update" : "create" }} query
  </p>
</template>

<style scoped>

</style>