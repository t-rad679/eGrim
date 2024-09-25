interface UserIdNameCompoundUniqueInput {
    userId_name: {
        userId: string,
        name: string,
    }
}

export function createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(
    userId: string,
    name: string,
): UserIdNameCompoundUniqueInput{
    return {
        userId_name: {
            userId,
            name,
        },
    }
}
