import * as models from "@out/type-graphql/models"
import { ResolversEnhanceMap } from "@typegraphql-prisma"
import { Authorized } from "type-graphql"


const entities = Object.keys(models)
export const resolversEnhanceMap: ResolversEnhanceMap = Object.fromEntries(
    entities.map(entity => [entity, { _all: [Authorized()] }]),
)
