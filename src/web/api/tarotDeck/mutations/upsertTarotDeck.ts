import {
    MutationUpsertOneTarotDeckArgs,
    TarotSuitAlias,
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
import { doAllTarotCardsQuery } from "@/api/tarotCard/queries/fetchAllTarotCards.js"
import { createUserWhereUniqueInputForMutations } from "@/api/user/userApiHelper.js"
import { DeepPartial } from "@/utils/DeepPartial.js"

interface UpsertTarotDeckResult {
    upsertOneTarotDeck: {
        id: string,
    },
}

export const UPSERT_TAROT_DECK = gql`
    mutation upsertTarotDeck($create: TarotDeckCreateInput!, $update: TarotDeckUpdateInput!, $where: TarotDeckWhereUniqueInput!) {
        upsertOneTarotDeck(create: $create, update: $update, where: $where) {
            id
        }
    }
    `

export function createUpsertTarotDeckMutation(): UseMutationReturn<UpsertTarotDeckResult, MutationUpsertOneTarotDeckArgs> {
    return useMutation(UPSERT_TAROT_DECK)
}

export function doUpsertTarotDeck(
    mutate: MutateFunction<UpsertTarotDeckResult, MutationUpsertOneTarotDeckArgs>,
    name: string,
    username: string,
    userId: string,
    notes: string,
    pictures: string[],
    suitAliasesToCreate: DeepPartial<TarotSuitAlias>[],
    suitAliasesToDelete: DeepPartial<TarotSuitAlias>[],
    tagNamesToCreate?: string[],
    tagIdsToDelete?: string[],
    existingTarotDeckId?: string,
    oldName?: string,
): void {
    const { onResult } = doAllTarotCardsQuery()
    onResult((result) => {
        if (result.loading) {
            return
        }
        if (!result.data?.tarotCards) {
            console.error("No tarot cards found. Not creating deck. Please contact support.")
            return
        }

        void mutate({
            create: {
                name,
                notes,
                pictures: { set: pictures },
                cards: {
                    createMany: {
                        data: result.data.tarotCards.map((card) => ({
                            cardId: card.id,
                        })),
                    },
                },
                suitAliases: {
                    create: suitAliasesToCreate.map((suitAlias) => ({
                        name: suitAlias.name ?? "",
                        suit: {
                            connect: {
                                name: suitAlias.suit!.name,
                            },
                        },
                    })),
                },
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
                name: { set: name },
                notes: { set: notes },
                pictures: { set: pictures },
                suitAliases: {
                    create: suitAliasesToCreate.map((suitAlias) => ({
                        name: suitAlias.name ?? "",
                        suit: {
                            connect: {
                                name: suitAlias.suit!.name,
                            },
                        },
                    })),
                    deleteMany: suitAliasesToDelete.map((suitAlias) => ({
                        name: { equals: suitAlias.name },
                        deckId: { equals: existingTarotDeckId },
                    })),
                },
                tags: {
                    create: tagNamesToCreate?.map((tag) => (createTagToObjectRelationCreateOrConnectInputForMutations(
                        tag,
                        username,
                        userId,
                    ))),
                    deleteMany: tagIdsToDelete?.map((tag) => (createTagToObjectRelationWhereUniqueInputForMutations(
                        tag,
                        {
                            tarotDeckId: { equals: existingTarotDeckId },
                        },
                    ))),
                },
            },
            where: createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(userId, oldName ?? ""),
        })
    })

}
