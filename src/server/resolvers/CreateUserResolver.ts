import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {User} from "../../../prisma/generated/type-graphql";
import {hashPassword} from "../auth/password";
import {randomBytes} from "crypto";
import {getPrismaFromContext} from "../../../prisma/generated/type-graphql/helpers";

@Resolver(_of => User)
export class CreateUserResolver {
    @Mutation(_returns => User, {nullable: false})
    async createUser(@Ctx() ctx: any, @Arg("username") username: string, @Arg("password") password: string) {
        const salt = randomBytes(16).toString()
        return getPrismaFromContext(ctx).user.create({
            data: {
                username: username,
                passwordHash: hashPassword(password, salt),
                passwordSalt: salt,
            }
        })
    }
}
