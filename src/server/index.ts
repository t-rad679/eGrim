import "reflect-metadata"
import path from "path"

import { ApolloServer } from "@apollo/server"
import { expressMiddleware } from "@apollo/server/express4"
import { PrismaClient } from "@prisma/client"
import bodyParser from "body-parser"
import cookieSession from "cookie-session"
import cors from "cors"
import express from "express"
import { buildSchema } from "type-graphql"

import { Context } from "@/server/context"
import { PopulateUser } from "@/server/middleware/PopulateUser"
import { LoginResolver } from "@/server/resolvers/LoginResolver"
import { RegisterResolver } from "@/server/resolvers/RegisterResolver"
import { FindFirstUserResolver, UserRelationsResolver } from "@typegraphql-prisma"

import CookieSessionRequest = CookieSessionInterfaces.CookieSessionRequest;

const GRAPHQL_PATH = "/graphql"

async function main() {
    const schema = await buildSchema({
        resolvers: [
            RegisterResolver,
            LoginResolver,
            FindFirstUserResolver,
            UserRelationsResolver,
        ],
        emitSchemaFile: path.resolve(__dirname, "../../out/generated-schema.graphql"),
        validate: false,
        globalMiddlewares: [PopulateUser],
    })
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
            secret: "shhhh",
            maxAge: 24 * 60 * 60 * 1000 * 365, // 1 year
            httpOnly: true,
        }),
    )
    app.use(
        GRAPHQL_PATH,
        cors({
            origin: ["https://studio.apollographql.com", "http://localhost:5173"],
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
    console.log(`GraphQL server ready at http://localhost:4000/${GRAPHQL_PATH}`)
}

main().catch(console.error)