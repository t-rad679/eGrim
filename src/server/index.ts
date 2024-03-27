import "reflect-metadata";
import cors from "cors"
import express from "express";
import { buildSchema } from "type-graphql";
import { ApolloServer } from "@apollo/server";
import bodyParser from "body-parser";
import path from "path";
import {PrismaClient, User} from "@prisma/client";

import {RegisterResolver} from "./resolvers/RegisterResolver";
import {FindFirstUserResolver, UserRelationsResolver} from "../../prisma/generated/type-graphql";
import {expressMiddleware} from "@apollo/server/express4";
import {LoginResolver} from "./resolvers/LoginResolver";
import cookieSession from "cookie-session";
import CookieSessionRequest = CookieSessionInterfaces.CookieSessionRequest;
import {PopulateUser} from "./middleware/PopulateUser";

export interface Context {
    prisma: PrismaClient;
    req: CookieSessionRequest,
    user?: User | null,
    count?: number
}

const GRAPHQL_PATH = "/graphql"
async function main() {
    const schema = await buildSchema({
        resolvers: [
            RegisterResolver,
            LoginResolver,
            FindFirstUserResolver,
            UserRelationsResolver,
        ],
        emitSchemaFile: path.resolve(__dirname, "./generated-schema.graphql"),
        validate: false,
        globalMiddlewares: [PopulateUser]
    });
    const prisma = new PrismaClient();
    await prisma.$connect();
    const app = express();
    const server = new ApolloServer<Context>({
        schema,
    });
    await server.start();

    app.use(
        GRAPHQL_PATH,
        cookieSession({
            name: "session",
            secret: "shhhh",
            maxAge: 24 * 60 * 60 * 1000 * 365 // 1 year
        })
    );
    app.use(
        GRAPHQL_PATH,
        cors({
            origin: ["https://studio.apollographql.com"]
        })
    )

    app.use(
        GRAPHQL_PATH,
        bodyParser.json(),
        expressMiddleware(server, {
            context: async ({ req }: any) => ({
                prisma,
                req: req
            })
        })
    )
    app.use((_, res) => {
        res.status(404);
        res.end();
    })

    await new Promise<void>(resolve => app.listen({ port: 4000 }, resolve));
    console.log(`GraphQL server ready at http://localhost:4000/${GRAPHQL_PATH}`);}

main().catch(console.error);