import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {User} from "../../../prisma/generated/type-graphql";
import {hashPassword} from "../auth/password";
import {randomBytes} from "crypto";
import {getPrismaFromContext} from "../../../prisma/generated/type-graphql/helpers";
import {Context} from "../index";

@Resolver(_of => User)
export class RegisterResolver {
    @Mutation(_returns => User, {nullable: false})
    async register(@Ctx() ctx: Context, @Arg("username") username: string, @Arg("password") password: string) {
        const salt = randomBytes(16).toString()
        return getPrismaFromContext(ctx).user.create({
            data: {
                username: username,
                passwordHash: hashPassword(password, salt),
            }
        })
    }
}
