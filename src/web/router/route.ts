import { Component } from "vue"

import CreateLocationForm from "@/components/forms/CreateOrUpdateLocationForm.vue"
import CreateOrUpdateTarotDeckForm from "@/components/forms/CreateOrUpdateTarotDeckForm.vue"
import CreatePersonView from "@/components/views/CreatePersonView.vue"
import LoginView from "@/components/views/LoginView.vue"
import RegisterView from "@/components/views/RegisterView.vue"
import UpdateLocationTestView from "@/components/views/UpdateLocationTestView.vue"
import UpdatePersonTestView from "@/components/views/UpdatePersonTestView.vue"
import UpdateTarotDeckView from "@/components/views/UpdateTarotDeckView.vue"
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
    UPDATE_LOCATION = "Update Form",
    CREATE_PERSON = "Create Person",
    UPDATE_PERSON = "Update Person",
    CREATE_DECK = "Create Deck",
    UPDATE_DECK = "Update Deck",
}

export const routes: RouteData[] = [
    { path: "/", component: RegisterView, title: Route.HOME , keyName: "" },
    { path: "/register", component: RegisterView, title: Route.REGISTER, keyName: "register" },
    { path: "/login", component: LoginView , title: Route.LOGIN, keyName: "login" },
    { path: "/location", component: CreateLocationForm, title: Route.CREATE_LOCATION, keyName: "create_location" },
    {
        path: "/update_location",
        component: UpdateLocationTestView,
        title: Route.UPDATE_LOCATION,
        keyName: "update_location",
    },
    {
        path: "/create_person",
        component: CreatePersonView,
        title: Route.CREATE_PERSON,
        keyName: "create_person",
    },
    {
        path: "/update_person",
        component: UpdatePersonTestView,
        title: Route.UPDATE_PERSON,
        keyName: "update_person",
    },
    {
        path: "/create_deck",
        component: CreateOrUpdateTarotDeckForm,
        title: Route.CREATE_DECK,
        keyName: "create_deck",
    },
    {
        path: "/update_deck",
        component: UpdateTarotDeckView,
        title: Route.UPDATE_DECK,
        keyName: "update_deck",
    },
]

export function getRouteData(route: Route): RouteData {
    return routes.find(r => {
        return r.title as Route === route
    })!
}
