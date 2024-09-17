import { User } from "@client-types"
import { provideApolloClient, useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"
import { defineStore } from "pinia"
import { Ref, ref } from "vue"

import { apolloClient } from "@/main"
import { DeepPartial } from "@/utils/DeepPartial"

export const useUserStore = defineStore("user", () => {
    const userFromLocalStorage: DeepPartial<User> = JSON.parse(localStorage.getItem("user") ?? "{}")
    const user: Ref<DeepPartial<User>> = ref({} as DeepPartial<User>)
    if (userFromLocalStorage) {
        user.value = {
            id: userFromLocalStorage.id,
            username: userFromLocalStorage.username,
            self: {
                name: userFromLocalStorage.self?.name,
            },
        }
    }
    provideApolloClient(apolloClient)
    return {
        user,
        login: setupLoginAction(user),
        register: setupRegisterAction(user),
        logout: () => {
            user.value = {
                id: "",
                username: "",
                self: {
                    name: "",
                },
            }
            localStorage.removeItem("user")
        },
    }
})

type loginFn = (username: string, password: string) => void

function setupLoginAction(user: Ref<DeepPartial<User>>): loginFn {
    const loginMutationText = gql`
        mutation login($user: String!, $pass: String!) {
            login(username: $user, password: $pass) {
                id
                username
                self {
                    name
                }
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

type registerFn = (username: string, password: string, name?: string) => void

function setupRegisterAction(user: Ref<DeepPartial<User>>): registerFn {
    const registerMutationText = gql`
        mutation register($user: String!, $pass: String!, $name: String!) {
            register(username: $user, password: $pass, name: $name) {
                id
                username
                self {
                    name
                }
            }
        }
    `
    const {
        mutate,
        onDone,
        onError,
    } = useMutation(registerMutationText)

    async function register(username: string, password: string, name?: string) {
        await mutate({
            user: username,
            pass: password,
            name,
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
