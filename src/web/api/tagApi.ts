import { Tag } from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

interface QueryFetchTagsResult {
    tags: Tag[]
}

interface CustomQueryFetchTagsArgs {
    userId: string,
}
const fetchTagsQueryText = gql`
    query fetchTags($userId: String!) {
        tags(where: { userId: { equals: $userId } }) {
            name
        }
    }
`

export function doTagsQuery(userId: string): UseQueryReturn<QueryFetchTagsResult, CustomQueryFetchTagsArgs> {
    return useQuery(fetchTagsQueryText, {
        userId,
    })
}
