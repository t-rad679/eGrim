<script setup lang="ts">
import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

import { Route, getRouteData } from "@/router/route"

const username = ref("")
const password = ref("")
const userData = ref({
    username: "",
    id: "",
})

const props = defineProps({
    title: String,
})

// We write both mutations out in full to get IDE integration with gql
let loginMutation = gql`
    mutation login($user: String!, $pass: String!) {
        login(username: $user, password: $pass) {
            id
            username
        }
    }
`
const registerMutation = gql`
    mutation register($user: String!, $pass: String!) {
        register(username: $user, password: $pass) {
            id
            username
        }
    }
`
const routeData = getRouteData(props.title as Route)
const { mutate, onDone, error } = useMutation(
    routeData.title === props.title ?
        loginMutation:
        registerMutation,
)

onDone((result) => {
    userData.value = result.data[routeData.keyName]
})

function executeMutation() {
    mutate({
        user: username.value,
        pass: password.value,
    })
}

const usernameRules = [
    (value: string) => (value ? true : "Please provide a username"),
]

const passwordRules = [
    (value: string) => (value.length > 0 ? true : "Please provide a password"),
    (value: string) => (value.length <= 64 ? true : "Password must be less than or equal to 64 characters"),
]
</script>

<template>
  <h2>{{ title }}</h2>
  <v-form
    validate-on="blur"
    @submit.prevent="executeMutation"
  >
    <v-text-field
      v-model="username"
      :rules="usernameRules"
      label="Username"
    />
    <v-text-field
      v-model="password"
      :rules="passwordRules"
      label="Password"
    />
    <p>
      <v-btn type="submit">
        {{ title }}
      </v-btn>
    </p>
  </v-form>
  <p v-if="userData">
    {{ userData }}
  </p>
  <p v-if="error">
    {{ error }}
  </p>
</template>
