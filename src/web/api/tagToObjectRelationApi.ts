import { type } from "node:os"

import {
    TagCreateNestedOneWithoutTagToObjectRelationsInput,
    TagToObjectRelationCreateOrConnectWithoutLocationInput,
    TagToObjectRelationCreateWithoutPersonInput, TagToObjectRelationScalarWhereInput,
} from "@client-types"

type TagToObjectRelationCreateWithoutXInput = {
    tag: TagCreateNestedOneWithoutTagToObjectRelationsInput,
}
export function createTagToObjectRelationCreateOrConnectInputForMutations(
    tagName: string,
    username: string,
    userId: string,
): TagToObjectRelationCreateWithoutXInput {
    return {
        tag: {
            connectOrCreate: {
                create: {
                    name: tagName,
                    user: {
                        connect: {
                            username,
                        },
                    },
                },
                where: {
                    userId_name: {
                        userId,
                        name: tagName,
                    },
                },
            },
        },
    }
}

export function createTagToObjectRelationWhereUniqueInputForMutations(
    tagId: string,
    filterClause: TagToObjectRelationScalarWhereInput,
): TagToObjectRelationScalarWhereInput {
    const deleteValue = {
        tagId: { equals: tagId },
        ...filterClause,
    }
    console.log(deleteValue)
    return deleteValue
}