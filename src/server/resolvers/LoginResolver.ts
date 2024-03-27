import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {Context} from "@/server";
import {User} from "../../../prisma/generated/type-graphql";
import {compareSync} from "bcryptjs";

@Resolver()
export class LoginResolver {
    @Mutation(() => User, { nullable: true })
    async login(
        @Ctx() ctx: Context,
        @Arg("username", _type => String) username: string,
        @Arg("password", _type => String) password: string
    ): Promise<User | null | undefined> {
        const user = await ctx.prisma.user.findUnique({
            where: { username }
        })

        if (!user) {
            return null;
        }

        if (!compareSync(password, user.passwordHash)) {
            return null;
        }

        return user
    }
}