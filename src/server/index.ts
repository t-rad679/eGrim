import "reflect-metadata";
import cors from "cors"
import express from "express";
import { expressjwt } from "express-jwt"
import { buildSchema } from "type-graphql";
import { ApolloServer } from "@apollo/server";
import bodyParser from "body-parser";
import path from "path";
import {PrismaClient, User} from "@prisma/client";

import {RegisterResolver} from "./resolvers/RegisterResolver";
import {FindFirstUserResolver, UserRelationsResolver} from "../../prisma/generated/type-graphql";
import {expressMiddleware} from "@apollo/server/express4";

export interface Context {
    prisma: PrismaClient;
    user?: User
}

const GRAPHQL_PATH = "/graphql"

async function main() {
    console.log("Testing")
    const schema = await buildSchema({
        resolvers: [
            RegisterResolver,
            FindFirstUserResolver,
            UserRelationsResolver,
        ],
        emitSchemaFile: path.resolve(__dirname, "./generated-schema.graphql"),
        validate: false,
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
        expressjwt({
            secret: "TypeGraphQL",
            algorithms: ["HS256"],
            credentialsRequired: false,
        }),
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
            context: async ({ req }) => ({
                prisma,
                user: (req as any).auth
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