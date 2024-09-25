import {
    MutationUpsertOnePersonArgs,
    Person,
    PersonUserIdNameCompoundUniqueInput,
} from "@client-types"
import {
    MutateFunction,
    UseMutationReturn,
    UseQueryReturn,
    useMutation,
    useQuery,
} from "@vue/apollo-composable"
import { gql } from "graphql-tag"

import { createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne } from "@/api/globalApiHelper"
import {
    createTagToObjectRelationCreateOrConnectInputForMutations,
    createTagToObjectRelationWhereUniqueInputForMutations,
} from "@/api/tagToObjectRelation/tagToObjectRelationApiHelper.js"
import { createUserWhereUniqueInputForMutations } from "@/api/user/userApiHelper"

interface QueryGetPersonResult {
    person: Person,
}

// I'm not sure why this is necessary. The type is essentially identical to QueryGetPersonArgs from @client-types
interface CustomQueryGetPersonArgs {
    where: {
        userId_name: PersonUserIdNameCompoundUniqueInput
    }
}

const personQueryText = gql`
    query person($where: PersonWhereUniqueInput!) {
        person(where: $where) {
            id
            name
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
export function doPersonQuery(
    name: string,
    userId: string,
): UseQueryReturn<QueryGetPersonResult, CustomQueryGetPersonArgs> {
    return useQuery(personQueryText, {
        where: {
            userId_name: {
                name,
                userId,
            },
        },
    })
}
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
