import { Component } from "vue"

import CreateLocationForm from "@/components/forms/CreateLocationForm.vue"
import CreatePersonView from "@/components/views/CreatePersonView.vue"
import LoginView from "@/components/views/LoginView.vue"
import RegisterView from "@/components/views/RegisterView.vue"
import UpdatePersonView from "@/components/views/UpdatePersonView.vue"

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
    // TODO: This might go away when we integrate it into the create ritual form
    CREATE_LOCATION = "Create Location",
    CREATE_PERSON = "Create Person",
    UPDATE_PERSON = "Update Person",
}

export const routes: RouteData[] = [
    { path: "/", component: RegisterView, title: Route.HOME , keyName: "" },
    { path: "/register", component: RegisterView, title: Route.REGISTER, keyName: "register" },
    { path: "/login", component: LoginView , title: Route.LOGIN, keyName: "login" },
    { path: "/location", component: CreateLocationForm, title: Route.CREATE_LOCATION, keyName: "create_location" },
    {
        path: "/create_person",
        component: CreatePersonView,
        title: Route.CREATE_PERSON,
        keyName: "create_person",
    },
    {
        path: "/update_person",
        component: UpdatePersonView,
        title: Route.UPDATE_PERSON,
        keyName: "update_person",
    },
]

export function getRouteData(route: Route): RouteData {
    return routes.find(r => {
        return r.title as Route === route
    })!
}