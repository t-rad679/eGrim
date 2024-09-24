import "reflect-metadata"
import path from "path"

import { ApolloServer } from "@apollo/server"
import { expressMiddleware } from "@apollo/server/express4"
import { PrismaClient } from "@prisma/client"
import {
    applyResolversEnhanceMap,
    resolvers,
} from "@typegraphql-prisma"
import bodyParser from "body-parser"
import cookieSession from "cookie-session"
import cors from "cors"
import express from "express"
import { buildSchema } from "type-graphql"

import { Context } from "@/context"
import { PopulateUser } from "@/middleware/PopulateUser"
import { LoginResolver } from "@/resolvers/LoginResolver"
import { RegisterResolver } from "@/resolvers/RegisterResolver"
import { resolversEnhanceMap } from "@/resolversEnhanceMap"

import CookieSessionRequest = CookieSessionInterfaces.CookieSessionRequest;

const GRAPHQL_PATH = "/graphql"

async function main() {
    applyResolversEnhanceMap(resolversEnhanceMap)
    const schema = await buildSchema({
        resolvers: [
            LoginResolver,
            RegisterResolver,
            // TODO: Figure out why this is necessary and only add the resolvers we actually need
            //       Hint: File a bug, but also try to find out if there's a way to separately add types and inputs
            //       without adding their corresponding resolvers
            ...resolvers,
        ],
        emitSchemaFile: path.resolve(__dirname, "../../out/generated-schema.graphql"),
        validate: false,
        globalMiddlewares: [PopulateUser],
        authChecker: ({ context }) => {
            return !!context.req.session.userId
        },
    })

    if(process.argv.includes("--generate_only")) {
        console.log("Generated schema. Exiting.")
        return
    }
    const prisma = new PrismaClient()
    await prisma.$connect()
    const app = express()
    const server = new ApolloServer<Context>({
        schema,
        introspection: true,
    })
    await server.start()

    app.use(
        GRAPHQL_PATH,
        cookieSession({
            name: "session",
            secret: process.env.AUTH_SECRET,
            maxAge: 24 * 60 * 60 * 1000 * 365, // 1 year
            httpOnly: true,
        }),
    )
    app.use(
        GRAPHQL_PATH,
        cors({
            origin: ["https://studio.apollographql.com", "http://localhost:5173"],
            credentials: true,
        }),
    )

    app.use(
        GRAPHQL_PATH,
        bodyParser.json(),
        expressMiddleware(server, {
            context: async ({ req }: { req: CookieSessionRequest }) => ({
                prisma,
                req: req,
            }),
        }),
    )
    app.use((_, res) => {
        res.status(404)
        res.end()
    })

    await new Promise<void>(resolve => app.listen({ port: 4000 }, resolve))
    console.log(`GraphQL server ready at http://localhost:4000${GRAPHQL_PATH}`)
}

main().catch(console.error)