import { User } from "@client-types"
import { provideApolloClient, useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { defineStore } from "pinia"
import { Ref, ref } from "vue"

import { apolloClient } from "@/main"
import { DeepPartial } from "@/utils/DeepPartial"

export const useUserStore = defineStore("user", () => {
    const userFromLocalStorage: DeepPartial<User> = JSON.parse(localStorage.getItem("user") ?? "{}")
    const user: Ref<DeepPartial<User>> = ref({
        id: userFromLocalStorage.id,
        username: userFromLocalStorage.username,
    })
    provideApolloClient(apolloClient)
    return {
        user,
        login: setupLoginAction(user),
        register: setupRegisterAction(user),
    }
})

function setupLoginAction(user: Ref<DeepPartial<User>>): Function {
    const loginMutationText = gql`
        mutation login($user: String!, $pass: String!) {
            login(username: $user, password: $pass) {
                id
                username
            }
        }
    `
    const {
        mutate: loginMutation,
        onDone: loginOnDone,
        onError: loginOnError,
    } = useMutation(loginMutationText)

    async function login(username: string, password: string) {
        console.log("executing login")
        await loginMutation({
            user: username,
            pass: password,
        })
    }

    loginOnDone((result) => {
        console.log("executing loginOnDone")
        user.value = result.data.login
        localStorage.setItem("user", JSON.stringify(user.value))
    })

    loginOnError((error) => {
        console.log(`Failed to log in: ${error.message}`)
        // TODO: Make a tooltip pop up
        // https://github.com/cornflourblue/vue-3-pinia-registration-login-example/blob/master/src/stores/alert.store.js
        // may be helpful
    })

    return login
}

function setupRegisterAction(user: Ref<DeepPartial<User>>): Function {
    const registerMutationText = gql`
        mutation register($user: String!, $pass: String!) {
            register(username: $user, password: $pass) {
                id
                username
            }
        }
    `
    const {
        mutate: registerMutation,
        onDone: registerOnDone,
        onError: registerOnError,
    } = useMutation(registerMutationText)

    async function register(username: string, password: string) {
        console.log("executing register")
        await registerMutation({
            user: username,
            pass: password,
        })
    }

    registerOnDone((result => {
        user.value = result.data.register
        localStorage.setItem("user", JSON.stringify(user.value))
    }))

    registerOnError((error) => {
        console.log(`Failed to register: ${error.message}`)
        // TODO: Tooltip
    })

    return register
}