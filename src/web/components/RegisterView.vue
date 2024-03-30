<script setup lang="ts">
import gql from "graphql-tag"
import { ref } from "vue"
import { useMutation } from "@apollo/client"

const username = ref("")
const password = ref("")
const registered = ref("Register")
const userData = ref({})
const errorData = ref("")


const [registerMutation, _] = useMutation(gql`
    mutation register($user: String!, $pass: String!) {
        register(username: $user, password: $pass) {
            id
            username
        }
    }
`, {
    onCompleted(data, _) {
        userData.value = data
    },
    onError(error, _) {
        errorData.value = error.message
    },
})


function register() {
    registerMutation({
        variables: {
            user: username.value,
            pass: password.value
        }
    })
}
</script>

<template>
  <p>
    Username
  </p>
  <input v-model="username">
  <p>
    Password
  </p>
  <input v-model="password">
  <p>
    <button @click="register">
      {{ registered }}
    </button>
  </p>
  <p v-if="userData">
    {{ userData }}
  </p>
  <p v-if="errorData">
    {{ errorData }}
  </p>
  <h1>{{ username }}</h1>
  <h1>{{ password }}</h1>
</template>
