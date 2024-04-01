<script setup lang="ts">
import { Routes, routes } from "@/router/routes"
</script>

<template>
  <v-app>
    <v-app-bar>
      <v-row class="text-right">
        <v-list nav>
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
        </v-list>
      </v-row>
    </v-app-bar>
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

