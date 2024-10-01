type UserIdNameCompoundUniqueInput = {
    userId_name: {
        userId: string,
        name: string,
    }
}

export type UserIdNameCompoundWhereUniqueInput = {
    where: UserIdNameCompoundUniqueInput,
}

// TODO: Rename this to reflect its use in queries and use it in all relevant queries
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
