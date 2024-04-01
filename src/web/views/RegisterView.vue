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


const { mutate: registerMutation, onDone, error } = useMutation(gql`
    mutation register($user: String!, $pass: String!) {
        register(username: $user, password: $pass) {
            id
            username
        }
    }
`)

onDone((result) => {
    userData.value = result.data.register
})

function register() {
    registerMutation({
        user: username.value,
        pass: password.value,
    })
}
</script>

<template>
  <h1>Register</h1>
  <v-text-field
    v-model="username"
    label="Username"
  />
  <v-text-field
    v-model="password"
    label="Password"
  />
  <p>
    <v-btn @click="register">
      Register
    </v-btn>
  </p>
  <p v-if="userData">
    {{ userData }}
  </p>
  <p v-if="error">
    {{ error }}
  </p>
</template>
