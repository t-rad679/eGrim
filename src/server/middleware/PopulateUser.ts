import { Context } from "@/server"
import { MiddlewareFn } from "type-graphql"

export const PopulateUser: MiddlewareFn<Context> = async ({ context }, next) => {
    let user = null
    if (context.req.session?.userId) {
        user = await context.prisma.user.findUnique({
            where: { id: context.req.session.userId }
        })
    }
    context.user = user

    return next()
}