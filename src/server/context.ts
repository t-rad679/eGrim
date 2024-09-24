import {
    PrismaClient,
    User,
} from "@prisma/client"

import CookieSessionRequest = CookieSessionInterfaces.CookieSessionRequest;

export interface Context {
    prisma: PrismaClient;
    req: CookieSessionRequest,
    user?: User | null,
}