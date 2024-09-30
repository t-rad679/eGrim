import { gql } from "@apollo/client"
import { MajorArcanaInfo } from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"

interface QueryFetchAllMajorArcanaInfosResult {
    majorArcanaInfos: MajorArcanaInfo[],
}
const FETCH_ALL_MAJOR_ARCANA_INFOS = gql`
  query FetchAllMajorArcanaInfos {
    majorArcanaInfos {
        name
        number
    }
  }
`

export function doAllMajorArcanaInfosQuery(): UseQueryReturn<QueryFetchAllMajorArcanaInfosResult, Record<string, never>> {
    return useQuery<QueryFetchAllMajorArcanaInfosResult>(FETCH_ALL_MAJOR_ARCANA_INFOS)
}
