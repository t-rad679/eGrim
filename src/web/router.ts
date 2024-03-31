import { createRouter,createWebHistory } from "vue-router"

import LoginView from "./components/LoginView.vue"
import RegisterView from "./components/RegisterView.vue"

const routes = [
    { path: "/register", component: RegisterView },
    { path: "/login", component: LoginView },
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router