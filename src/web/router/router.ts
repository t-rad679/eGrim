import { createRouter, createWebHistory } from "vue-router"

import { routes } from "@/web/router/routes"

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router