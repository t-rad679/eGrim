import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {hashSync} from "bcryptjs"
import {User} from "../../../prisma/generated/type-graphql";
import {Context} from "../index";

@Resolver()
export class RegisterResolver {
    @Mutation(_returns => User, {nullable: false})
    async register(
        @Ctx() ctx: Context,
        @Arg("username", _type => String) username: string,
        @Arg("password", _type => String) password: string
    ): Promise<User> {
        return ctx.prisma.user.create({
            data: {
                username: username,
                passwordHash: hashSync(password, 8),
            }
        })
    }
}
