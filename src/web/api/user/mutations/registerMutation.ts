import {
    MutationRegisterArgs,
    User,
} from "@client-types"
import {
    MutateFunction,
    UseMutationReturn,
    useMutation,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

export interface RegisterResult {
    register: User,
}

const registerMutationText = gql`
    mutation register($username: String!, $password: String!, $name: String!) {
        register(username: $username, password: $password, name: $name) {
            id
            username
            self {
                name
            }
        }
    }
`

export function createRegisterMutation(): UseMutationReturn<RegisterResult, MutationRegisterArgs> {
    return useMutation(registerMutationText)
}

export async function doRegister(
    mutate: MutateFunction<RegisterResult, MutationRegisterArgs>,
    username: string,
    password: string,
    name?: string,
): Promise<void> {
    await mutate({
        username: username,
        password,
        name,
    })
}