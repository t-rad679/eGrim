import { Arg, Ctx, Mutation, Resolver } from "type-graphql"
import { Context } from "../index"
import { User } from "@typegraphql-prisma"
import { hashSync } from "bcryptjs"

@Resolver()
export class RegisterResolver {
    @Mutation(() => User, { nullable: false })
    async register(
        @Ctx() ctx: Context,
        @Arg("username", () => String) username: string,
        @Arg("password", () => String) password: string
    ): Promise<User> {
        return ctx.prisma.user.create({
            data: {
                username: username,
                passwordHash: hashSync(password, 8),
            }
        })
    }
}
