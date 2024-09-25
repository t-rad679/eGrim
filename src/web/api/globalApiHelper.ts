import {
    LocationWhereUniqueInput,
    PersonWhereUniqueInput,
} from "@client-types"

type XWhereUniqueInput = LocationWhereUniqueInput | PersonWhereUniqueInput
export function createUserIdNameCompoundUniqueInputForUpdateOrUpsertOne(
    userId: string,
    name: string,
): XWhereUniqueInput{
    return {
        userId_name: {
            userId,
            name,
        },
    }
}
