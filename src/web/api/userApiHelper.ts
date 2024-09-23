
import { UserCreateNestedOneWithoutPeopleInput } from "@client-types"

type UserCreateNestedOneWithoutXInput = (
        UserCreateNestedOneWithoutPeopleInput
)
export function createUserWhereUniqueInputForMutations(username: string): UserCreateNestedOneWithoutXInput {
    return {
        connect: {
            username,
        },
    }
}