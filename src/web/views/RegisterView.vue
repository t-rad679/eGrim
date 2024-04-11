<script setup lang="ts">
import LoginOrRegisterComponent from "@/components/LoginOrRegisterComponent.vue"
import { Route } from "@/router/route"

</script>

<template>
  <LoginOrRegisterComponent
    :title="Route.REGISTER"
  />
</template>
