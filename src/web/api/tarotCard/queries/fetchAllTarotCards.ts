import { TarotCard } from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

interface QueryFetchTarotCardsResult {
    tarotCards: TarotCard[],
}
export const FETCH_ALL_TAROT_CARDS = gql`
    query FetchAllTarotCards {
        tarotCards {
            id
        }
    }
`

export function doAllTarotCardsQuery(): UseQueryReturn<QueryFetchTarotCardsResult, {}>{
    return useQuery(FETCH_ALL_TAROT_CARDS)
}
