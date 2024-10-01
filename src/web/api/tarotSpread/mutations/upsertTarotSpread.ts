import {
    MutationUpsertOneTarotSpreadArgs,
    TarotPosition,
} from "@client-types"
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
import { DeepPartial } from "@/utils/DeepPartial.js"

type UpsertTarotSpreadResult = {
    upsertOneTarotSpread: {
        id: string,
    },
}

const UPSERT_TAROT_SPREAD = gql`
    mutation upsertTarotSpread($create: TarotSpreadCreateInput!, $update: TarotSpreadUpdateInput!, $where: TarotSpreadWhereUniqueInput!) {
        upsertOneTarotSpread(create: $create, update: $update, where: $where) {
            id
        }
    }
    `

export function createUpsertTarotSpreadMutation(): UseMutationReturn<UpsertTarotSpreadResult, MutationUpsertOneTarotSpreadArgs> {
    return useMutation(UPSERT_TAROT_SPREAD)
}

export function doUpsertTarotSpread(
    mutate: MutateFunction<UpsertTarotSpreadResult, MutationUpsertOneTarotSpreadArgs>,
    name: string,
    username: string,
    userId: string,
    description: string,
    positions: DeepPartial<TarotPosition>[],
    tagNamesToCreate?: string[],
    tagIdsToDelete?: string[],
    existingTarotSpreadId?: string,
    oldName?: string,
): void {
    void mutate(
        {
            create: {
                name,
                description,
                positions: {
                    create: positions.map((position) => ({
                        number: position.number!,
                        description: position.description,
                    })),
                },
                tags: {
                    create: tagNamesToCreate?.map((tag) => (
                        createTagToObjectRelationCreateOrConnectInputForMutations(
                            tag,
                            username,
                            userId,
                        ))),
                },
                user: createUserWhereUniqueInputForMutations(username),
            },
            update: {
                name: { set: name },
                description: { set: description },
                positions: {
                    update: positions.map((position) => ({
                        where: {
                            id: position.id ?? "",
                        },
                        data: {
                            // We only support updating the description for now
                            description: { set: position.description },
                        },
                    })),
                },
                tags: {
                    create: tagNamesToCreate?.map((tag) => (
                        createTagToObjectRelationCreateOrConnectInputForMutations(
                            tag,
                            username,
                            userId,
                        ))),
                    deleteMany: tagIdsToDelete?.map((tag) => (
                        createTagToObjectRelationWhereUniqueInputForMutations(
                            tag,
                            {
                                tarotSpreadId: { equals: existingTarotSpreadId },
                            },
                        ))),
                },
            },
            where: createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(userId, oldName ?? ""),
        })
}
