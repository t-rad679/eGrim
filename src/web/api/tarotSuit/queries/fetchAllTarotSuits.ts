import { TarotSuit } from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

interface QueryFetchAllTarotSuitsResult {
    tarotSuits: TarotSuit[],
}

const FETCH_ALL_TAROT_SUITS = gql`
  query FetchAllTarotSuits {
    tarotSuits {
      name
    }
  }
`

export function doAllTarotSuitsQuery(): UseQueryReturn<QueryFetchAllTarotSuitsResult, {}> {
    return useQuery<{ tarotSuits: TarotSuit[] }>(FETCH_ALL_TAROT_SUITS)
}
