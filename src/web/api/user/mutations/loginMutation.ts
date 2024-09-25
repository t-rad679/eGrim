import {
    MutationLoginArgs,
    User,
} from "@client-types"
import {
    MutateFunction,
    UseMutationReturn,
    useMutation,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

const loginMutationText = gql`
    mutation login($username: String!, $password: String!) {
        login(username: $username, password: $password) {
            id
            username
            self {
                name
            }
        }
    }
`

export interface LoginResult {
    login: User
}

export function createLoginMutation(): UseMutationReturn<LoginResult, MutationLoginArgs> {
    return useMutation(loginMutationText)
}

export async function doLogin(
    mutate: MutateFunction<LoginResult, MutationLoginArgs>,
    username: string,
    password: string,
): Promise<void> {
    await mutate({
        username,
        password,
    })
}