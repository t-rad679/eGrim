import {
    Location,
    LocationUserIdNameCompoundUniqueInput,
} from "@client-types"
import {
    UseQueryReturn,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

interface QueryGetLocationResult {
    location: Location,
}

// I'm not sure why this is necessary. The type is essentially identical to QueryGetLocationArgs from @client-types
interface CustomQueryGetLocationArgs {
    where: {
        userId_name: LocationUserIdNameCompoundUniqueInput,
    },
}

const locationQueryText = gql`
    query location($where: LocationWhereUniqueInput!) {
        location(where: $where) {
            id
            name
            address
            city
            state
            zip
            country
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

export function doLocationQuery(
    name: string,
    userId: string,
): UseQueryReturn<QueryGetLocationResult, CustomQueryGetLocationArgs> {
    return useQuery(locationQueryText, {
        where: {
            userId_name: {
                name,
                userId,
            },
        },
    })
}

