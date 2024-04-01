import { Component } from "vue"

import LoginView from "@/views/LoginView.vue"
import RegisterView from "@/views/RegisterView.vue"

interface RouteData {
    path: string,
    component: Component,
    title: Route,
}

export enum Route {
    HOME = "",
    REGISTER = "Register",
    LOGIN = "Login",
}

export const routes: RouteData[] = [
    { path: "/", component: RegisterView, title: Route.HOME },
    { path: "/register", component: RegisterView, title: Route.REGISTER },
    { path: "/login", component: LoginView , title: Route.LOGIN },
]

export function getRouteData(route: Route): RouteData {
    return routes.find(r => {
        return r.title as Route === route
    })!
}