import {MiddlewareFn} from "type-graphql";
import {Context} from "@/server";

export const PopulateUser: MiddlewareFn<Context> = async ({ context }, next) => {
    let user = null;
    if (context.req.session?.userId) {
        user = await context.prisma.user.findUnique({
            where: {id: context.req.session.userId}
        })
    }
    context.user = user
    if (context.count === undefined) {
        context.count = 0
    }
    return next();
}