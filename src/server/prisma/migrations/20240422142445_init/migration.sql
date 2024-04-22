-- CreateEnum
CREATE TYPE "Role" AS ENUM ('USER', 'ADMIN');

-- CreateEnum
CREATE TYPE "RitualType" AS ENUM ('TAROT', 'GENERAL');

-- CreateEnum
CREATE TYPE "RitualRole" AS ENUM ('PARTICIPANT', 'LEADER', 'SPECTATOR', 'QUERENT', 'READER');

-- CreateEnum
CREATE TYPE "TarotSuit" AS ENUM ('SWORDS', 'WANDS', 'PENTACLES', 'CUPS', 'MAJOR_ARCANA');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "username" TEXT NOT NULL,
    "roles" "Role"[] DEFAULT ARRAY['USER']::"Role"[],
    "personId" TEXT,
    "passwordHash" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ritual" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" "RitualType" NOT NULL,
    "description" TEXT NOT NULL,
    "steps" TEXT[],
    "date" TIMESTAMP(3) NOT NULL,
    "moonPhase" DECIMAL(65,30) NOT NULL,
    "pictures" TEXT[],
    "notes" TEXT,
    "outdoor" BOOLEAN NOT NULL DEFAULT false,
    "userId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "toolRelationId" TEXT NOT NULL,
    "resultsId" TEXT NOT NULL,

    CONSTRAINT "Ritual_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tool" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tool_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ToolToRitualRelation" (
    "toolId" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,

    CONSTRAINT "ToolToRitualRelation_pkey" PRIMARY KEY ("toolId","ritualId")
);

-- CreateTable
CREATE TABLE "WielderPersonToToolRelationRelation" (
    "toolToRitualRelationToolId" TEXT NOT NULL,
    "toolToRitualRelationRitualId" TEXT NOT NULL,
    "wielderId" TEXT NOT NULL,

    CONSTRAINT "WielderPersonToToolRelationRelation_pkey" PRIMARY KEY ("toolToRitualRelationToolId","toolToRitualRelationRitualId","wielderId")
);

-- CreateTable
CREATE TABLE "Location" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "city" TEXT NOT NULL DEFAULT 'Atlanta',
    "state" TEXT NOT NULL DEFAULT 'GA',
    "country" TEXT NOT NULL DEFAULT 'USA',
    "description" TEXT,

    CONSTRAINT "Location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ParticipantPersonToRitualRelation" (
    "role" "RitualRole" NOT NULL,
    "personId" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,

    CONSTRAINT "ParticipantPersonToRitualRelation_pkey" PRIMARY KEY ("personId","ritualId")
);

-- CreateTable
CREATE TABLE "TarotReading" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ritualId" TEXT NOT NULL,
    "tarotSpreadId" TEXT NOT NULL,

    CONSTRAINT "TarotReading_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotSpread" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "TarotSpread_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotPosition" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "number" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "tarotSpreadId" TEXT NOT NULL,

    CONSTRAINT "TarotPosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotCardDraw" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "tarotReadingId" TEXT NOT NULL,
    "tarotPositionId" TEXT NOT NULL,

    CONSTRAINT "TarotCardDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotCard" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "suit" "TarotSuit" NOT NULL,
    "number" INTEGER NOT NULL,
    "notes" TEXT NOT NULL,

    CONSTRAINT "TarotCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotDeckCard" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "notes" TEXT NOT NULL,
    "pictures" TEXT NOT NULL,
    "tarotCardId" TEXT NOT NULL,
    "tarotDeckId" TEXT NOT NULL,

    CONSTRAINT "TarotDeckCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotDeck" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT NOT NULL,

    CONSTRAINT "TarotDeck_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Person" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Person_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "text" TEXT NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TagRelation" (
    "id" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "ritualId" TEXT,
    "toolId" TEXT,
    "tarotCardDrawId" TEXT,
    "tarotCardId" TEXT,
    "tarotDeckCardId" TEXT,
    "tarotDeckId" TEXT,
    "tarotPositionId" TEXT,
    "personId" TEXT,
    "ritualResultsId" TEXT,
    "locationId" TEXT,

    CONSTRAINT "TagRelation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RitualResults" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "success" BOOLEAN NOT NULL,
    "notes" TEXT,

    CONSTRAINT "RitualResults_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_personId_key" ON "User"("personId");

-- CreateIndex
CREATE UNIQUE INDEX "TarotReading_ritualId_key" ON "TarotReading"("ritualId");

-- CreateIndex
CREATE UNIQUE INDEX "Person_name_key" ON "Person"("name");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ritual" ADD CONSTRAINT "Ritual_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ritual" ADD CONSTRAINT "Ritual_resultsId_fkey" FOREIGN KEY ("resultsId") REFERENCES "RitualResults"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ritual" ADD CONSTRAINT "Ritual_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ToolToRitualRelation" ADD CONSTRAINT "ToolToRitualRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ToolToRitualRelation" ADD CONSTRAINT "ToolToRitualRelation_toolId_fkey" FOREIGN KEY ("toolId") REFERENCES "Tool"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WielderPersonToToolRelationRelation" ADD CONSTRAINT "WielderPersonToToolRelationRelation_toolToRitualRelationTo_fkey" FOREIGN KEY ("toolToRitualRelationToolId", "toolToRitualRelationRitualId") REFERENCES "ToolToRitualRelation"("toolId", "ritualId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WielderPersonToToolRelationRelation" ADD CONSTRAINT "WielderPersonToToolRelationRelation_wielderId_fkey" FOREIGN KEY ("wielderId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantPersonToRitualRelation" ADD CONSTRAINT "ParticipantPersonToRitualRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantPersonToRitualRelation" ADD CONSTRAINT "ParticipantPersonToRitualRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReading" ADD CONSTRAINT "TarotReading_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReading" ADD CONSTRAINT "TarotReading_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotPosition" ADD CONSTRAINT "TarotPosition_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_tarotPositionId_fkey" FOREIGN KEY ("tarotPositionId") REFERENCES "TarotPosition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_tarotReadingId_fkey" FOREIGN KEY ("tarotReadingId") REFERENCES "TarotReading"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeckCard" ADD CONSTRAINT "TarotDeckCard_tarotCardId_fkey" FOREIGN KEY ("tarotCardId") REFERENCES "TarotCard"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeckCard" ADD CONSTRAINT "TarotDeckCard_tarotDeckId_fkey" FOREIGN KEY ("tarotDeckId") REFERENCES "TarotDeck"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_toolId_fkey" FOREIGN KEY ("toolId") REFERENCES "Tool"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_tarotCardDrawId_fkey" FOREIGN KEY ("tarotCardDrawId") REFERENCES "TarotCardDraw"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_tarotCardId_fkey" FOREIGN KEY ("tarotCardId") REFERENCES "TarotCard"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_tarotDeckCardId_fkey" FOREIGN KEY ("tarotDeckCardId") REFERENCES "TarotDeckCard"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_tarotDeckId_fkey" FOREIGN KEY ("tarotDeckId") REFERENCES "TarotDeck"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_tarotPositionId_fkey" FOREIGN KEY ("tarotPositionId") REFERENCES "TarotPosition"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_ritualResultsId_fkey" FOREIGN KEY ("ritualResultsId") REFERENCES "RitualResults"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagRelation" ADD CONSTRAINT "TagRelation_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE SET NULL ON UPDATE CASCADE;
