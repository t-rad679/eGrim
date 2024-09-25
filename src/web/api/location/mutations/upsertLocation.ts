import { MutationUpsertOneLocationArgs } from "@client-types"
import {
    MutateFunction,
    UseMutationReturn,
    useMutation,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

import { createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne } from "@/api/globalApiHelper.js"
import {
    createTagToObjectRelationCreateOrConnectInputForMutations,
    createTagToObjectRelationWhereUniqueInputForMutations,
} from "@/api/tagToObjectRelation/tagToObjectRelationApiHelper.js"
import { createUserWhereUniqueInputForMutations } from "@/api/user/userApiHelper.js"

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
