<script setup lang="ts">
import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"
import { defineComponent } from "vue-demi"

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

// We write both queries out in full to get IDE integration with gql
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
const { mutate, onDone, error } = useMutation(
    getRouteData(Route.LOGIN).title === props.title ?
        loginMutation:
        registerMutation,
)

onDone((result) => {
    userData.value = result.data.login
})

function executeMutation() {
    mutate({
        user: username.value,
        pass: password.value,
    })
}
</script>

<template>
  <h2>{{ title }}</h2>
  <v-text-field
    v-model="username"
    label="Username"
  />
  <v-text-field
    v-model="password"
    label="Password"
  />
  <p>
    <v-btn @click="executeMutation">
      {{ title }}
    </v-btn>
  </p>
  <p v-if="userData">
    {{ userData }}
  </p>
  <p v-if="error">
    {{ error }}
  </p>
</template>
