import { ApolloQueryResult } from "@apollo/client"
import { ApolloError } from "@apollo/client/core"
import { User } from "@client-types"
import { provideApolloClient } from "@vue/apollo-composable"
import { defineStore } from "pinia"
import {
    Ref,
    ref,
} from "vue"

import {
    LoginResult,
    createLoginMutation,
    doLogin,
} from "@/api/user/mutations/loginMutation"
import {
    RegisterResult,
    createRegisterMutation,
    doRegister,
} from "@/api/user/mutations/registerMutation"
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
    const {
        mutate,
        onDone,
        onError,
    } = createLoginMutation()

    async function login(username: string, password: string) {
        await doLogin(mutate, username, password)
    }

    onDone((result: ApolloQueryResult<LoginResult>) => {
        if(result?.data?.login) {
            user.value = result.data.login
            localStorage.setItem("user", JSON.stringify(user.value))
        }
    })

    onError((error: ApolloError) => {
        console.log(`Failed to log in: ${error}`)
        // TODO: Make a tooltip pop up
        // https://github.com/cornflourblue/vue-3-pinia-registration-login-example/blob/master/src/stores/alert.store.js
        // may be helpful
    })

    return login
}

type registerFn = (username: string, password: string, name?: string) => void

function setupRegisterAction(user: Ref<DeepPartial<User>>): registerFn {
    const {
        mutate,
        onDone,
        onError,
    } = createRegisterMutation()

    async function register(username: string, password: string, name?: string) {
        await doRegister(
            mutate,
            username,
            password,
            name,
        )
    }

    onDone((result: ApolloQueryResult<RegisterResult>) => {
        if (result?.data?.register) {
            user.value = result.data.register
            localStorage.setItem("user", JSON.stringify(user.value))
        }
    })

    onError((error: ApolloError) => {
        console.log(`Failed to register: ${error}`)
        // TODO: Tooltip
    })

    return register
}
