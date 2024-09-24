<script setup lang="ts">

import { computed } from "vue"

import {
    Route,
    getRouteData,
} from "@/router/route"
import { useUserStore } from "@/stores/UserStore"

const userStore = useUserStore()
const user = computed(() => userStore.user)

function handleLogout() {
    userStore.logout()
}
</script>

<template>
  <v-app-bar>
    <v-row class="text-right">
      <v-col class="text-left">
        <h1>
          eGrim
        </h1>
        <template v-if="!!user?.self?.name">
          Hello, {{ user.self.name }}!
        </template>
      </v-col>
      <v-col>
        <template v-if="!user?.id">
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
        </template>
        <template v-else>
          <router-link
            v-slot="{ navigate }"
            :to="getRouteData(Route.CREATE_PERSON).path"
          >
            <v-btn @click="navigate">
              Create Person
            </v-btn>
          </router-link>
          <router-link
            v-slot="{ navigate }"
            :to="getRouteData(Route.UPDATE_PERSON).path"
          >
            <v-btn @click="navigate">
              Update Person
            </v-btn>
          </router-link>
          <router-link
            v-slot="{ navigate }"
            :to="getRouteData(Route.CREATE_LOCATION).path"
          >
            <v-btn @click="navigate">
              Create Location
            </v-btn>
          </router-link>
          <router-link
            :to="getRouteData(Route.LOGIN).path"
          >
            <v-btn @click="handleLogout">
              Logout
            </v-btn>
          </router-link>
          <router-link
            v-slot="{ navigate }"
            :to="getRouteData(Route.UPDATE_LOCATION).path"
          >
            <v-btn @click="navigate">
              Update Location
            </v-btn>
          </router-link>
        </template>
      </v-col>
    </v-row>
  </v-app-bar>
</template>