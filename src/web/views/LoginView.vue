<script setup lang="ts">
import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

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
  <v-text-field
    v-model="username"
    label="Username"
  />
  <v-text-field
    v-model="password"
    label="Password"
  />
  <p>
    <v-btn @click="login">
      Login
    </v-btn>
  </p>
  <p v-if="userData">
    {{ userData }}
  </p>
  <p v-if="error">
    {{ error }}
  </p>
</template>
