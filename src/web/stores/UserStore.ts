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

type loginOrRegisterFn = (username: string, password: string) => void

function setupLoginAction(user: Ref<DeepPartial<User>>): loginOrRegisterFn {
    const loginMutationText = gql`
        mutation login($user: String!, $pass: String!) {
            login(username: $user, password: $pass) {
                id
                username
            }
        }
    `
    const {
        mutate,
        onDone,
        onError,
    } = useMutation(loginMutationText)

    async function login(username: string, password: string) {
        await mutate({
            user: username,
            pass: password,
        })
    }

    onDone((result) => {
        user.value = result.data.login
        localStorage.setItem("user", JSON.stringify(user.value))
    })

    onError((error) => {
        console.log(`Failed to log in: ${error.message}`)
        // TODO: Make a tooltip pop up
        // https://github.com/cornflourblue/vue-3-pinia-registration-login-example/blob/master/src/stores/alert.store.js
        // may be helpful
    })

    return login
}

function setupRegisterAction(user: Ref<DeepPartial<User>>): loginOrRegisterFn {
    const registerMutationText = gql`
        mutation register($user: String!, $pass: String!) {
            register(username: $user, password: $pass) {
                id
                username
            }
        }
    `
    const {
        mutate,
        onDone,
        onError,
    } = useMutation(registerMutationText)

    async function register(username: string, password: string) {
        await mutate({
            user: username,
            pass: password,
        })
    }

    onDone((result => {
        user.value = result.data.register
        localStorage.setItem("user", JSON.stringify(user.value))
    }))

    onError((error) => {
        console.log(`Failed to register: ${error.message}`)
        // TODO: Tooltip
    })

    return register
}