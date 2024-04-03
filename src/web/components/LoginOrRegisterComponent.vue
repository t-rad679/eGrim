<script setup lang="ts">
import { ref } from "vue"

import { Route } from "@/router/route"
import { useUserStore } from "@/stores/UserStore"

const username = ref("")
const password = ref("")

const props = defineProps({
    title: {
        type: String,
        required: true,
    },
})

const userStore = useUserStore()

function onSubmit() {
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
    (value: string) => (value ? true : "Username is required"),
]

const passwordRules = [
    (value: string) => (value.length > 0 ? true : "Password is required"),
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
      type="password"
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
