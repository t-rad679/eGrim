import {
    TarotDeck,
    TarotDeckUserIdNameCompoundUniqueInput,
} from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

import { createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne } from "@/api/globalApiHelper.js"

interface QueryGetTarotDeckResult {
    tarotDeck: TarotDeck,
}

// I'm not sure why this is necessary. The type is essentially identical to QueryGetTarotDeckArgs from @client-types
interface CustomQueryGetTarotDeckArgs {
    where: {
        userId_name: TarotDeckUserIdNameCompoundUniqueInput,
    },
}

const tarotDeckQueryText = gql`
    query tarotDeck($where: TarotDeckWhereUniqueInput!) {
        tarotDeck(where: $where) {
            id
            name
            notes
            pictures
            suitAliases {
                name
                suit {
                    name
                }
            }
            tags {
                tag {
                    id
                    name
                }
            }
        }
    }
`

export function doTarotDeckQuery(
    name: string,
    userId: string,
): UseQueryReturn<QueryGetTarotDeckResult, CustomQueryGetTarotDeckArgs> {
    return useQuery(tarotDeckQueryText, {
        where: createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(userId, name),
    })
}
