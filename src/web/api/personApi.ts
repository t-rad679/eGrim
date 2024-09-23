import { MutationUpsertOnePersonArgs } from "@client-types"
import { MutateFunction, UseMutationReturn, useMutation } from "@vue/apollo-composable"
import { gql } from "graphql-tag"

import { createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne } from "@/api/globalApiHelper.js"
import {
    createTagToObjectRelationCreateOrConnectInputForMutations,
    createTagToObjectRelationWhereUniqueInputForMutations,
} from "@/api/tagToObjectRelationApi.js"
import { createUserWhereUniqueInputForMutations } from "@/api/userApi.js"

interface UpsertPersonResult {
    upsertOnePerson: {
        id: string
    }
}

const upsertPersonMutationText = gql`
    mutation upsertPersonMutation(
        $create: PersonCreateInput!,
        $update: PersonUpdateInput!,
        $where: PersonWhereUniqueInput!
    ) {
        upsertOnePerson(create: $create, update: $update, where: $where) {
            id
        }
    }
`

export function createUpsertPersonMutation(): UseMutationReturn<UpsertPersonResult, MutationUpsertOnePersonArgs> {
    return useMutation(upsertPersonMutationText)
}

export function doUpsertPerson(
    mutate: MutateFunction<UpsertPersonResult, MutationUpsertOnePersonArgs>,
    newName: string,
    description: string,
    username: string,
    userId: string,
    tagNamesToCreate?: string[],
    tagIdsToDelete?: string[],
    existingPersonId?: string,
    oldName?: string,
): void {
    mutate({
        create: {
            name: newName,
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
            description: { set: description },
            tags: {
                create: tagNamesToCreate?.map((tag) => (createTagToObjectRelationCreateOrConnectInputForMutations(
                    tag,
                    username,
                    userId,
                ))),
                deleteMany: tagIdsToDelete?.map((tag) => (
                    // TODO: See if there's a way we can achieve type safety without using ?? "" and DeepPartial
                    createTagToObjectRelationWhereUniqueInputForMutations(
                        tag,
                        {
                            personId: { equals: existingPersonId },
                        },
                    ))),
            },
        },
        where: createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(userId, oldName ?? ""),
    })
}