import {
    Location,
    LocationUserIdNameCompoundUniqueInput,
    MutationUpsertOneLocationArgs,
} from "@client-types"
import {
    MutateFunction,
    UseMutationReturn,
    UseQueryReturn,
    useMutation,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

import { createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne } from "@/api/globalApiHelper.js"
import {
    createTagToObjectRelationCreateOrConnectInputForMutations,
    createTagToObjectRelationWhereUniqueInputForMutations,
} from "@/api/tagToObjectRelationApi.js"
import { createUserWhereUniqueInputForMutations } from "@/api/user/userApiHelper"

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

interface UpsertLocationResult {
    upsertOneLocation: {
        id: string,
    }
}

const locationUpsertMutationText = gql`
    mutation upsertLocation($create: LocationCreateInput!, $update: LocationUpdateInput!, $where: LocationWhereUniqueInput!) {
        upsertOneLocation(create: $create, update: $update, where: $where) {
            id
        }
    }
`

export function createUpsertLocationMutation(): UseMutationReturn<UpsertLocationResult, MutationUpsertOneLocationArgs> {
    return useMutation(locationUpsertMutationText)
}

export function doUpsertLocation(
    mutate: MutateFunction<UpsertLocationResult, MutationUpsertOneLocationArgs>,
    newName: string,
    username: string,
    userId: string,
    address: string,
    city: string,
    state: string,
    zip: string,
    country: string,
    description: string,
    tagNamesToCreate?: string[],
    tagIdsToDelete?: string[],
    existingLocationId?: string,
    oldName?: string,
): void {
    mutate({
        create: {
            name: newName,
            address,
            city,
            state,
            zip,
            country,
            description,
            tags: {
                create: tagNamesToCreate?.map((tag) => (createTagToObjectRelationCreateOrConnectInputForMutations(
                    tag,
                    username,
                    userId,
                ))),
            },
            user: createUserWhereUniqueInputForMutations(username),
        },
        update: {
            name: { set: newName },
            address: { set: address },
            city: { set: city },
            state: { set: state },
            zip: { set: zip },
            country: { set: country },
            description: { set: description },
            tags: {
                create: tagNamesToCreate?.map((tag) => (createTagToObjectRelationCreateOrConnectInputForMutations(
                    tag,
                    username,
                    userId,
                ))),
                deleteMany: tagIdsToDelete?.map((tag) => (createTagToObjectRelationWhereUniqueInputForMutations(
                    tag,
                    {
                        locationId: { equals: existingLocationId },
                    },
                ))),
            },
        },
        where: createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(userId, oldName ?? ""),
    })
}