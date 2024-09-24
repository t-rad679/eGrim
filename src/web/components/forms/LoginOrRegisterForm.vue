<script setup lang="ts">
import { ref } from "vue"

import { Route } from "@/router/route"
import { useUserStore } from "@/stores/UserStore"
import { createFieldRequiredRule } from "@/utils/validationUtils"

const username = ref("")
const password = ref("")
const name = ref("")

const props = defineProps({
    title: {
        type: String,
        required: true,
    },
})

const userStore = useUserStore()

function onSubmit() {
    if(props.title === Route.LOGIN) {
        userStore.login(username.value, password.value)
    } else if(props.title === Route.REGISTER) {
        userStore.register(username.value, password.value, name.value)
    } else {
        throw new Error("Invalid title for this component")
    }
}

const usernameRules = [createFieldRequiredRule("Username")]

const passwordRules = [
    createFieldRequiredRule("Password"),
    (value: string) => (value.length <= 64 ? true : "Password must be less than or equal to 64 characters"),
]
</script>

<template>
  <v-form
    validate-on="blur"
    class="w-50"
    @submit.prevent="onSubmit"
  >
    <h2>{{ title }}</h2>

    <v-text-field
      v-model="username"
      :rules="usernameRules"
      label="Username"
      class="required"
    />
    <v-text-field
      v-model="password"
      type="password"
      :rules="passwordRules"
      label="Password"
      class="required"
    />
    <p v-if="title === Route.REGISTER">
      <!-- TODO(https://github.com/t-rad679/egrim/issues/50): Add a tooltip -->
      <v-text-field
        v-model="name"
        label="Name (Will use Username if not provided)"
      />
    </p>
    <p>
      <v-btn type="submit">
        {{ title }}
      </v-btn>
    </p>
  </v-form>
  <!-- TODO: Figure out what to really do here -->
  <p v-if="userStore.user">
    {{ userStore.user }}
  </p>
</template>
