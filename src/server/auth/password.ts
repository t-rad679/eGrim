import {createHash, randomBytes} from "crypto";

export function hashPassword(password: string, salt: string): string {
    return createHash('sha256').update(salt + password).digest('hex')
}
