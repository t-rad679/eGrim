import {
    TagCreateNestedOneWithoutTagToObjectRelationsInput,
    TagToObjectRelationScalarWhereInput,
} from "@client-types"

// TODO: See if there's a way to do this with generic types
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
    return {
        tagId: { equals: tagId },
        ...filterClause,
    }
}
