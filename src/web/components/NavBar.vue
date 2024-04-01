<script setup lang="ts">

import { Routes } from "@/router/routes"
</script>

<template>
  <v-app-bar>
    <v-list nav>
      <router-link
        :to="Routes.REGISTER"
        tag="v-btn"
      >
        <v-btn>
          Register
        </v-btn>
      </router-link>
      <router-link
        :to="Routes.LOGIN"
        tag="v-btn"
      >
        <v-btn>
          Login
        </v-btn>
      </router-link>
    </v-list>
  </v-app-bar>
</template>