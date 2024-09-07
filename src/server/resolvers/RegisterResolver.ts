import { User } from "@typegraphql-prisma"
import { hashSync } from "bcryptjs"
import { Args, ArgsType, Ctx, Field, Mutation, Resolver } from "type-graphql"

import { Context } from "@/context"

@ArgsType()
class RegisterArgs {
    @Field(_ => String) username: string

    @Field(_ => String) password: string

    @Field(_ => String, { nullable: true }) name?: string
}

@Resolver()
export class RegisterResolver {
    @Mutation(() => User, { nullable: false })
    async register(
        @Ctx() ctx: Context,
        @Args() { username, password, name }: RegisterArgs,
    ): Promise<User> {
        const finalName = name ? name : username
        // TODO: Check if the username is taken on blur
        return ctx.prisma.user.create({
            data: {
                username: username,
                passwordHash: hashSync(password, 8),
                self: {
                    create: {
                        name: finalName,
                        user: {
                            connect: { username: username },
                        },
                    },
                },
            },
        })
    }
}
