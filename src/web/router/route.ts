import { Component } from "vue"

import CreateLocationForm from "@/components/CreateLocationForm.vue"
import LoginView from "@/views/LoginView.vue"
import RegisterView from "@/views/RegisterView.vue"

interface RouteData {
    title: Route,
    path: string,
    component: Component,
    keyName: string,
}

export enum Route {
    HOME = "",
    REGISTER = "Register",
    LOGIN = "Login",
    // TODO: This will go away when we integrate it into the create ritual form
    CREATE_LOCATION = "Create Location",
}

export const routes: RouteData[] = [
    { path: "/", component: RegisterView, title: Route.HOME , keyName: "" },
    { path: "/register", component: RegisterView, title: Route.REGISTER, keyName: "register" },
    { path: "/login", component: LoginView , title: Route.LOGIN, keyName: "login" },
    { path: "/location", component: CreateLocationForm, title: Route.CREATE_LOCATION, keyName: "create_location" },
]

export function getRouteData(route: Route): RouteData {
    return routes.find(r => {
        return r.title as Route === route
    })!
}