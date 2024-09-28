import { PrismaClient } from "@prisma/client"

const TAROT_SUITS = ["Wands", "Cups", "Swords", "Pentacles"]

const TAROT_RANKS = [
    "Ace",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Page",
    "Knight",
    "Queen",
    "King",
].map((name, index) => ({ name, number: index + 1 }))

const MAJOR_ARCANA = [
    "The Fool",
    "The Magician",
    "The High Priestess",
    "The Empress",
    "The Emperor",
    "The Hierophant",
    "The Lovers",
    "The Chariot",
    "Strength",
    "The Hermit",
    "Wheel of Fortune",
    "Justice",
    "The Hanged Man",
    "Death",
    "Temperance",
    "The Devil",
    "The Tower",
    "The Star",
    "The Moon",
    "The Sun",
    "Judgement",
    "The World",
].map((name, index) => ({ name, number: index }))

const prisma = new PrismaClient()
async function main() {
    await createSuits()
    await createRanks()
    await createMinorArcana()
    await createMajorArcana()
}

async function createSuits(): Promise<void> {
    await prisma.tarotSuit.createMany({
        data: TAROT_SUITS.map((name) => ({ name })),
    })
}

async function createRanks(): Promise<void> {
    await prisma.tarotRank.createMany({
        data: TAROT_RANKS,
    })
}

async function createMinorArcana(): Promise<void> {
    const suits = await prisma.tarotSuit.findMany()
    const ranks = await prisma.tarotRank.findMany()
    const minorArcana = suits.flatMap((suit) =>
        ranks.map((rank) => ({
            suitId: suit.id,
            rankId: rank.id,
        })),
    )
    await prisma.tarotCard.createMany({
        data: minorArcana,
    })
}

async function createMajorArcana(): Promise<void> {
    for(const { name, number } of MAJOR_ARCANA) {
        await prisma.tarotCard.create({
            data: {
                majorArcanaInfo: {
                    create: {
                        name,
                        number,
                    },
                },
            },
        })
    }
}

main()
    .then(() => {
        console.log("Seed successful")
    }).catch((error) => {
        console.error(error)
    }).finally(async () => {
        await prisma.$disconnect()
    })
