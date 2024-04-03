<script setup lang="ts">
import { useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { ref } from "vue"

import { Route, getRouteData } from "@/router/route"
import { useUserStore } from "@/stores/UserStore"

const username = ref("")
const password = ref("")
const userData = ref({
    username: "",
    id: "",
})

const props = defineProps({
    title: String,
})

const userStore = useUserStore()

function onSubmit() {
    console.log("executing onSubmit")
    console.log(props.title)
    if(props.title === Route.LOGIN) {
        userStore.login(username.value, password.value)
    } else if(props.title === Route.REGISTER) {
        userStore.register(username.value, password.value)
    } else {
        throw new Error("Invalid title for this component")
    }

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
    @submit.prevent="onSubmit"
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
  <p v-if="userStore.user">
    {{ userStore.user }}
  </p>
</template>
