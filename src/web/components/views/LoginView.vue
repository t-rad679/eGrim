<script setup lang="ts">
import LoginOrRegisterComponent from "@/components/forms/LoginOrRegisterForm.vue"
import { Route } from "@/router/route.js"
</script>

<template>
  <LoginOrRegisterComponent :title="Route.LOGIN" />
</template>
