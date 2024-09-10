<script setup lang="ts">

import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

import TagField from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore.js"

// TODO: Add optional address
// TODO: Add tags
const name = ref("")
const city = ref("")
const state = ref("")
const country = ref("")
const description = ref("")
const success = ref(false)
const errorMessage = ref("")

const userStore = useUserStore()
const username = userStore.user.username

const nameRules = [
    (value: string) => (value ? true : "Name is required"),
]

// The id is not actually needed but GraphQL requires that we return something
const createLocationMutationText = gql`
        mutation createLocation($input: LocationCreateInput!) {
            createOneLocation(data: $input) {
                id
            }
        }
    `

const {
    mutate,
    onDone,
    onError,
} = useMutation(createLocationMutationText)

function onSubmit() {
    async function createLocation(
        name: string,
        city: string,
        state: string,
        country: string,
        description?: string,
    ) {
        onDone((_) => {
            success.value = true
        })

        onError((error) => {
            errorMessage.value = error.message
        })
        await mutate({ input: {
            name,
            city,
            state,
            country,
            description,
            user: {
                connect: {
                    username,
                },
            },
        } })
    }

    createLocation(
        name.value,
        city.value,
        state.value,
        country.value,
        description.value,
    )
}

</script>

<template>
  <v-form
    validate-on="blur"
    class="w-50"
    @submit.prevent="onSubmit"
  >
    <h2>Create Location</h2>
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="The name you want to identify this location by"
    />
    <v-text-field
      v-model="city"
      label="The city of the location"
    />
    <v-text-field
      v-model="state"
      label="The state or province of the location"
    />
    <v-text-field
      v-model="country"
      label="The three letter country code of the location"
    />
    <v-text-field
      v-model="description"
      label="What kind of place is it? What is it like?"
    />
    <TagField />
    <v-btn type="submit">
      Create Location
    </v-btn>
  </v-form>
  {{ success }}
  <p v-if="errorMessage">
    {{ errorMessage }}
  </p>
</template>

<style scoped>

</style>