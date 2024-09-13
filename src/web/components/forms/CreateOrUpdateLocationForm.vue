<script setup lang="ts">

import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

import TagInput from "@/components/inputs/TagInput.vue"
import { useUserStore } from "@/stores/UserStore.js"

// TODO: Add optional address
// TODO: Add tags
const name = ref("")
const address = ref("")
const city = ref("")
const state = ref("")
const country = ref("")
const zip = ref("")
const tags = ref([])
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
        address: string,
        city: string,
        state: string,
        zip: string,
        country: string,
        description: string,
        tags: string[],
    ) {
        onDone((_) => {
            success.value = true
        })

        onError((error) => {
            errorMessage.value = error.message
        })
        await mutate({ input: {
            name,
            address,
            city,
            state,
            zip,
            country,
            description,
            tags: {
                create: tags.map((tag) => ({
                    tag: {
                        connect: {
                            userId_name: {
                                userId: userStore.user.id,
                                name: tag,
                            },
                        },
                    },
                })),
            },
            user: {
                connect: {
                    username,
                },
            },
        } })
    }

    createLocation(
        name.value,
        address.value,
        city.value,
        state.value,
        zip.value,
        country.value,
        description.value,
        tags.value,
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
      v-model="address"
      label="The street address of the location"
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
      v-model="zip"
      label="The postal code of the location"
    />
    <v-text-field
      v-model="country"
      label="The three letter country code of the location"
    />
    <v-text-field
      v-model="description"
      label="What kind of place is it? What is it like?"
    />
    <TagInput v-model="tags" />
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