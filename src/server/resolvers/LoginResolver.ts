import { User } from "@typegraphql-prisma"
import { compareSync } from "bcryptjs"
import { Arg, Ctx, Mutation, Resolver } from "type-graphql"

import { Context } from "@/context"

@Resolver()
export class LoginResolver {
    @Mutation(() => User, { nullable: true })
    async login(
        @Ctx() ctx: Context,
        @Arg("username", () => String) username: string,
        @Arg("password", () => String) password: string,
    ): Promise<User | null | undefined> {
        const user = await ctx.prisma.user.findUnique({
            where: { username },
        })

        if (!user) {
            return null
        }

        if (!compareSync(password, user.passwordHash)) {
            return null
        }

        ctx.req.session!.userId = user.id

        return user
    }
}