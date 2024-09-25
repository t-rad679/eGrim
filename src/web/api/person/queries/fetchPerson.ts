import {
    Person,
    PersonUserIdNameCompoundUniqueInput,
} from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

interface QueryGetPersonResult {
    person: Person,
}

// I'm not sure why this is necessary. The type is essentially identical to QueryGetPersonArgs from @client-types
interface CustomQueryGetPersonArgs {
    where: {
        userId_name: PersonUserIdNameCompoundUniqueInput
    }
}

const personQueryText = gql`
    query person($where: PersonWhereUniqueInput!) {
        person(where: $where) {
            id
            name
            description
            tags {
                tag {
                    id
                    name
                }
            }
        }
    }
`
export function doPersonQuery(
    name: string,
    userId: string,
): UseQueryReturn<QueryGetPersonResult, CustomQueryGetPersonArgs> {
    return useQuery(personQueryText, {
        where: {
            userId_name: {
                name,
                userId,
            },
        },
    })
}

