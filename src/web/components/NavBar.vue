<script setup lang="ts">

import { Routes } from "@/router/routes"
</script>

<template>
  <v-app-bar>
    <v-row class="text-right">
      <v-col class="text-left">
        <h1>
          eGrim
        </h1>
      </v-col>
      <v-col>
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
      </v-col>
    </v-row>
  </v-app-bar>
</template>