-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'USER');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('JOURNAL_ENTRY', 'RITUAL', 'SPOOKY_THING', 'SYNCHRONICITY', 'TAROT');

-- CreateEnum
CREATE TYPE "RitualRole" AS ENUM ('LEADER', 'PARTICIPANT', 'SPECTATOR');

-- CreateEnum
CREATE TYPE "TarotRole" AS ENUM ('QUERENT', 'READER');

-- CreateEnum
CREATE TYPE "TarotSuit" AS ENUM ('CUPS', 'PENTACLES', 'SWORDS', 'WANDS', 'MAJOR_ARCANA');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "roles" "Role"[] DEFAULT ARRAY['USER']::"Role"[],
    "passwordHash" TEXT NOT NULL,
    "username" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Event" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "locationId" TEXT,
    "type" "EventType" NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "description" TEXT NOT NULL,
    "mood" TEXT,
    "moonPhase" DECIMAL(65,30) NOT NULL,
    "notes" TEXT,
    "outdoor" BOOLEAN NOT NULL DEFAULT false,
    "pictures" TEXT[],
    "dummy" INTEGER,

    CONSTRAINT "Event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Location" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "address" TEXT,
    "city" TEXT,
    "country" TEXT,
    "description" TEXT,
    "name" TEXT NOT NULL,
    "state" TEXT,

    CONSTRAINT "Location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Person" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "selfUserId" TEXT,
    "name" TEXT NOT NULL,

    CONSTRAINT "Person_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TagToObjectRelation" (
    "id" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "eventId" TEXT,
    "locationId" TEXT,
    "personId" TEXT,
    "ritualResultsId" TEXT,
    "tarotCardId" TEXT,
    "tarotCardDrawId" TEXT,
    "tarotDeckId" TEXT,
    "tarotDeckCardId" TEXT,
    "tarotPositionId" TEXT,
    "toolId" TEXT,
    "tarotSpreadId" TEXT,
    "dummy" INTEGER,

    CONSTRAINT "TagToObjectRelation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ritual" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "eventId" TEXT NOT NULL,
    "toolRelationId" TEXT NOT NULL,
    "steps" TEXT[],

    CONSTRAINT "Ritual_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RitualResults" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "success" BOOLEAN NOT NULL,
    "notes" TEXT,
    "ritualId" TEXT NOT NULL,

    CONSTRAINT "RitualResults_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tool" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tool_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ToolToRitualRelation" (
    "ritualId" TEXT NOT NULL,
    "toolId" TEXT NOT NULL,
    "dummy" INTEGER,

    CONSTRAINT "ToolToRitualRelation_pkey" PRIMARY KEY ("toolId","ritualId")
);

-- CreateTable
CREATE TABLE "WielderPersonToToolRelationRelation" (
    "toolToRitualRelationRitualId" TEXT NOT NULL,
    "toolToRitualRelationToolId" TEXT NOT NULL,
    "wielderId" TEXT NOT NULL,
    "dummy" INTEGER,

    CONSTRAINT "WielderPersonToToolRelationRelation_pkey" PRIMARY KEY ("toolToRitualRelationRitualId","toolToRitualRelationToolId","wielderId")
);

-- CreateTable
CREATE TABLE "ParticipantPersonToRitualRelation" (
    "personId" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,
    "role" "RitualRole" NOT NULL,

    CONSTRAINT "ParticipantPersonToRitualRelation_pkey" PRIMARY KEY ("personId","ritualId")
);

-- CreateTable
CREATE TABLE "TarotReading" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "eventId" TEXT NOT NULL,
    "spreadId" TEXT NOT NULL,
    "dummy" INTEGER,

    CONSTRAINT "TarotReading_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotQuerentOrReaderPersonRelation" (
    "personId" TEXT NOT NULL,
    "tarotReadingId" TEXT NOT NULL,
    "role" "TarotRole" NOT NULL,

    CONSTRAINT "TarotQuerentOrReaderPersonRelation_pkey" PRIMARY KEY ("personId","role","tarotReadingId")
);

-- CreateTable
CREATE TABLE "TarotSpread" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "TarotSpread_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotPosition" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "tarotSpreadId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "number" INTEGER NOT NULL,

    CONSTRAINT "TarotPosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotCardDraw" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "positionId" TEXT NOT NULL,
    "tarotReadingId" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "TarotCardDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotCard" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "suit" "TarotSuit" NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "number" INTEGER NOT NULL,

    CONSTRAINT "TarotCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotDeckCard" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "cardId" TEXT NOT NULL,
    "tarotDeckId" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "pictures" TEXT NOT NULL,

    CONSTRAINT "TarotDeckCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotDeck" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT NOT NULL,

    CONSTRAINT "TarotDeck_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Location_name_key" ON "Location"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Person_selfUserId_key" ON "Person"("selfUserId");

-- CreateIndex
CREATE UNIQUE INDEX "Person_userId_name_key" ON "Person"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_userId_name_key" ON "Tag"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Ritual_eventId_key" ON "Ritual"("eventId");

-- CreateIndex
CREATE UNIQUE INDEX "RitualResults_ritualId_key" ON "RitualResults"("ritualId");

-- CreateIndex
CREATE UNIQUE INDEX "TarotReading_eventId_key" ON "TarotReading"("eventId");

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Location" ADD CONSTRAINT "Location_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Person" ADD CONSTRAINT "Person_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Person" ADD CONSTRAINT "Person_selfUserId_fkey" FOREIGN KEY ("selfUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_ritualResultsId_fkey" FOREIGN KEY ("ritualResultsId") REFERENCES "RitualResults"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotCardId_fkey" FOREIGN KEY ("tarotCardId") REFERENCES "TarotCard"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotCardDrawId_fkey" FOREIGN KEY ("tarotCardDrawId") REFERENCES "TarotCardDraw"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotDeckId_fkey" FOREIGN KEY ("tarotDeckId") REFERENCES "TarotDeck"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotDeckCardId_fkey" FOREIGN KEY ("tarotDeckCardId") REFERENCES "TarotDeckCard"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotPositionId_fkey" FOREIGN KEY ("tarotPositionId") REFERENCES "TarotPosition"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_toolId_fkey" FOREIGN KEY ("toolId") REFERENCES "Tool"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ritual" ADD CONSTRAINT "Ritual_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualResults" ADD CONSTRAINT "RitualResults_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tool" ADD CONSTRAINT "Tool_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ToolToRitualRelation" ADD CONSTRAINT "ToolToRitualRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ToolToRitualRelation" ADD CONSTRAINT "ToolToRitualRelation_toolId_fkey" FOREIGN KEY ("toolId") REFERENCES "Tool"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WielderPersonToToolRelationRelation" ADD CONSTRAINT "WielderPersonToToolRelationRelation_wielderId_fkey" FOREIGN KEY ("wielderId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WielderPersonToToolRelationRelation" ADD CONSTRAINT "WielderPersonToToolRelationRelation_toolToRitualRelationTo_fkey" FOREIGN KEY ("toolToRitualRelationToolId", "toolToRitualRelationRitualId") REFERENCES "ToolToRitualRelation"("toolId", "ritualId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantPersonToRitualRelation" ADD CONSTRAINT "ParticipantPersonToRitualRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantPersonToRitualRelation" ADD CONSTRAINT "ParticipantPersonToRitualRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReading" ADD CONSTRAINT "TarotReading_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReading" ADD CONSTRAINT "TarotReading_spreadId_fkey" FOREIGN KEY ("spreadId") REFERENCES "TarotSpread"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotQuerentOrReaderPersonRelation" ADD CONSTRAINT "TarotQuerentOrReaderPersonRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotQuerentOrReaderPersonRelation" ADD CONSTRAINT "TarotQuerentOrReaderPersonRelation_tarotReadingId_fkey" FOREIGN KEY ("tarotReadingId") REFERENCES "TarotReading"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotSpread" ADD CONSTRAINT "TarotSpread_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotPosition" ADD CONSTRAINT "TarotPosition_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "TarotPosition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_tarotReadingId_fkey" FOREIGN KEY ("tarotReadingId") REFERENCES "TarotReading"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeckCard" ADD CONSTRAINT "TarotDeckCard_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "TarotCard"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeckCard" ADD CONSTRAINT "TarotDeckCard_tarotDeckId_fkey" FOREIGN KEY ("tarotDeckId") REFERENCES "TarotDeck"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeck" ADD CONSTRAINT "TarotDeck_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
