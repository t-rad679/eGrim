<script setup lang="ts">

import { Route, getRouteData } from "@/router/route"
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
          :to="getRouteData(Route.REGISTER).path"
          tag="v-btn"
        >
          <v-btn>
            Register
          </v-btn>
        </router-link>
        <router-link
          :to="getRouteData(Route.LOGIN).path"
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