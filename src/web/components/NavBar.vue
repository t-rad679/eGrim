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
          v-slot="{ navigate }"
          :to="getRouteData(Route.REGISTER).path"
        >
          <v-btn @click="navigate">
            Register
          </v-btn>
        </router-link>
        <router-link
          v-slot="{ navigate }"
          :to="getRouteData(Route.LOGIN).path"
        >
          <v-btn @click="navigate">
            Login
          </v-btn>
        </router-link>
        <!-- TODO: Add Location route -->
        <router-link
          v-slot="{ navigate }"
          :to="getRouteData(Route.CREATE_PERSON).path"
        >
          <v-btn @click="navigate">
            Create Person
          </v-btn>
        </router-link>
      </v-col>
    </v-row>
  </v-app-bar>
</template>