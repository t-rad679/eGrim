<script setup lang="ts">

import gql from "graphql-tag"
import { ref } from "vue"
import { useMutation } from "@vue/apollo-composable"

const username = ref("")
const password = ref("")
const userData = ref({
    username: "",
    id: "",
})

const { mutate: loginMutation, onDone, error } = useMutation(gql`
    mutation login($user: String!, $pass: String!) {
        login(username: $user, password: $pass) {
            id
            username
        }
    }
`)

onDone((result) => {
    userData.value = result.data.login
})

function login() {
    loginMutation({
        user: username.value,
        pass: password.value,
    })
}
</script>

<template>
  <h1>Login</h1>
  <p>
    Username
  </p>
  <input v-model="username">
  <p>
    Password
  </p>
  <input v-model="password">
  <p>
    <button @click="login">
      Login
    </button>
  </p>
  <p v-if="userData">
    {{ userData }}
  </p>
  <p v-if="error">
    {{ error }}
  </p>
</template>
