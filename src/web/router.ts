import { createRouter,createWebHistory } from "vue-router"

import RegisterView from "./components/RegisterView.vue"

const routes = [
    { path: "/", component: RegisterView }
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router