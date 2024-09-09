<script setup lang="ts">

import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

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

const cityRules = [
    (value: string) => (value ? true : "City is required"),
]

const stateRules = [
    (value: string) => (value ? true : "State is required"),
    (value: string) => (value.length === 2 ? true : "State must be a two letter code"),
]

const countryRules = [
    (value: string) => (value ? true : "Country is required"),
    (value: string) => (value.length === 3 ? true : "Country must be a three letter code"),
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
        await mutate({
            input: {
                name,
                city,
                state,
                country,
                description,
                user: {
                    connect: {
                        username: username,
                    },
                },
            },
        })
    }

    onDone((_) => {
        success.value = true
    })

    onError((error) => {
        errorMessage.value = error.message
    })

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
      label="Name"
    />
    <v-text-field
      v-model="city"
      :rules="cityRules"
      label="City"
    />
    <v-text-field
      v-model="state"
      :rules="stateRules"
      label="State"
    />
    <v-text-field
      v-model="country"
      :rules="countryRules"
      label="Country"
    />
    <v-text-field
      v-model="description"
      label="What kind of place is it? What is it like?"
    />
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