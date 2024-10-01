import { TarotSpread } from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

import {
    UserIdNameCompoundWhereUniqueInput,
    createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne,
} from "@/api/globalApiHelper.js"

const FETCH_TAROT_SPREAD = gql`
  query tarotSpread($where: TarotSpreadWhereUniqueInput!) {
    tarotSpread(where: $where) {
      id
      name
      description
      tags {
        tag {
            id
            name
        }
      }
      positions {
        id
        number
        description
      }
    }
  }
`

interface QueryGetTarotSpreadResult {
  tarotSpread: TarotSpread;
}

export function doTarotSpreadQuery(
    name: string,
    userId: string,
): UseQueryReturn<QueryGetTarotSpreadResult, UserIdNameCompoundWhereUniqueInput> {
    return useQuery(
        FETCH_TAROT_SPREAD,
        {
            where: createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(userId, name),
        },
    )
}
