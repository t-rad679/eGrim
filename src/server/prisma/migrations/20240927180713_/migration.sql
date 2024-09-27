-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'USER');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('JOURNAL_ENTRY', 'RITUAL', 'SPOOKY_THING', 'SYNCHRONICITY', 'TAROT');

-- CreateEnum
CREATE TYPE "RitualRole" AS ENUM ('LEADER', 'PARTICIPANT', 'SPECTATOR');

-- CreateEnum
CREATE TYPE "TarotRole" AS ENUM ('QUERENT', 'READER');

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
    "name" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "address" TEXT,
    "city" TEXT,
    "country" TEXT,
    "description" TEXT,
    "state" TEXT,
    "zip" TEXT,

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
    "description" TEXT,

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
    "ritualId" TEXT,
    "ritualResultId" TEXT,
    "ritualStepId" TEXT,
    "tarotCardId" TEXT,
    "tarotCardDrawId" TEXT,
    "tarotDeckId" TEXT,
    "tarotDeckCardId" TEXT,
    "tarotPositionId" TEXT,
    "tarotSpreadId" TEXT,
    "toolId" TEXT,
    "dummy" INTEGER,

    CONSTRAINT "TagToObjectRelation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ritual" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT,
    "description" TEXT,

    CONSTRAINT "Ritual_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RitualStep" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ritualId" TEXT NOT NULL,
    "composedRitualId" TEXT NOT NULL,
    "tarotSpreadId" TEXT,
    "description" TEXT NOT NULL,
    "number" INTEGER NOT NULL,

    CONSTRAINT "RitualStep_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RitualObservance" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "eventId" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "RitualObservance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RitualResult" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "success" BOOLEAN NOT NULL,
    "notes" TEXT,
    "ritualObservanceId" TEXT NOT NULL,

    CONSTRAINT "RitualResult_pkey" PRIMARY KEY ("id")
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
CREATE TABLE "ParticipantPersonToRitualObservanceRelation" (
    "personId" TEXT NOT NULL,
    "ritualObservanceId" TEXT NOT NULL,
    "role" "RitualRole" NOT NULL,

    CONSTRAINT "ParticipantPersonToRitualObservanceRelation_pkey" PRIMARY KEY ("personId","ritualObservanceId")
);

-- CreateTable
CREATE TABLE "WielderPersonToToolRelation" (
    "personId" TEXT NOT NULL,
    "ritualObservanceId" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,
    "toolId" TEXT NOT NULL,
    "dummy" INTEGER,

    CONSTRAINT "WielderPersonToToolRelation_pkey" PRIMARY KEY ("ritualId","toolId","personId","ritualObservanceId")
);

-- CreateTable
CREATE TABLE "TarotReading" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "dummy" INTEGER,

    CONSTRAINT "TarotReading_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PersonTarotRoleRelation" (
    "personId" TEXT NOT NULL,
    "tarotReadingId" TEXT NOT NULL,
    "role" "TarotRole" NOT NULL,

    CONSTRAINT "PersonTarotRoleRelation_pkey" PRIMARY KEY ("personId","role","tarotReadingId")
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
    "majorArcanaNumberId" TEXT,
    "rankId" TEXT,
    "suitId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT,
    "commonMeaning" TEXT,
    "commonReversedMeaning" TEXT,

    CONSTRAINT "TarotCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotSuit" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "TarotSuit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotSuitAlias" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deckId" TEXT NOT NULL,
    "suitId" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "TarotSuitAlias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotRank" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "number" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "TarotRank_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MajorArcanaNumber" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "number" INTEGER NOT NULL,
    "notes" TEXT NOT NULL,

    CONSTRAINT "MajorArcanaNumber_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MajorArcanaAlias" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deckId" TEXT NOT NULL,
    "numberId" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "MajorArcanaAlias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotDeckCard" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "cardId" TEXT NOT NULL,
    "tarotDeckId" TEXT NOT NULL,
    "alias" TEXT,
    "meaning" TEXT,
    "picture" TEXT,
    "reversedMeaning" TEXT,

    CONSTRAINT "TarotDeckCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotDeck" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "TarotDeck_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarotReadingToRitualObservanceAndStepRelation" (
    "ritualObservanceId" TEXT NOT NULL,
    "ritualStepId" TEXT NOT NULL,
    "tarotReadingId" TEXT NOT NULL,
    "dummy" INTEGER,

    CONSTRAINT "TarotReadingToRitualObservanceAndStepRelation_pkey" PRIMARY KEY ("ritualObservanceId","ritualStepId","tarotReadingId")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Location_userId_name_key" ON "Location"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Person_selfUserId_key" ON "Person"("selfUserId");

-- CreateIndex
CREATE UNIQUE INDEX "Person_userId_name_key" ON "Person"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_userId_name_key" ON "Tag"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "TagToObjectRelation_tagId_eventId_locationId_personId_ritua_key" ON "TagToObjectRelation"("tagId", "eventId", "locationId", "personId", "ritualId", "ritualResultId", "ritualStepId", "tarotCardId", "tarotCardDrawId", "tarotDeckId", "tarotDeckCardId", "tarotPositionId", "toolId", "tarotSpreadId");

-- CreateIndex
CREATE UNIQUE INDEX "RitualStep_ritualId_number_key" ON "RitualStep"("ritualId", "number");

-- CreateIndex
CREATE UNIQUE INDEX "RitualObservance_eventId_key" ON "RitualObservance"("eventId");

-- CreateIndex
CREATE UNIQUE INDEX "RitualResult_ritualObservanceId_key" ON "RitualResult"("ritualObservanceId");

-- CreateIndex
CREATE UNIQUE INDEX "TarotCard_majorArcanaNumberId_rankId_suitId_key" ON "TarotCard"("majorArcanaNumberId", "rankId", "suitId");

-- CreateIndex
CREATE UNIQUE INDEX "TarotSuitAlias_deckId_suitId_key" ON "TarotSuitAlias"("deckId", "suitId");

-- CreateIndex
CREATE UNIQUE INDEX "TarotRank_number_key" ON "TarotRank"("number");

-- CreateIndex
CREATE UNIQUE INDEX "TarotRank_name_key" ON "TarotRank"("name");

-- CreateIndex
CREATE UNIQUE INDEX "MajorArcanaNumber_number_key" ON "MajorArcanaNumber"("number");

-- CreateIndex
CREATE UNIQUE INDEX "MajorArcanaAlias_deckId_numberId_key" ON "MajorArcanaAlias"("deckId", "numberId");

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
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_ritualResultId_fkey" FOREIGN KEY ("ritualResultId") REFERENCES "RitualResult"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_ritualStepId_fkey" FOREIGN KEY ("ritualStepId") REFERENCES "RitualStep"("id") ON DELETE SET NULL ON UPDATE CASCADE;

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
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagToObjectRelation" ADD CONSTRAINT "TagToObjectRelation_toolId_fkey" FOREIGN KEY ("toolId") REFERENCES "Tool"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ritual" ADD CONSTRAINT "Ritual_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualStep" ADD CONSTRAINT "RitualStep_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualStep" ADD CONSTRAINT "RitualStep_composedRitualId_fkey" FOREIGN KEY ("composedRitualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualStep" ADD CONSTRAINT "RitualStep_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualObservance" ADD CONSTRAINT "RitualObservance_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualObservance" ADD CONSTRAINT "RitualObservance_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RitualResult" ADD CONSTRAINT "RitualResult_ritualObservanceId_fkey" FOREIGN KEY ("ritualObservanceId") REFERENCES "RitualObservance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tool" ADD CONSTRAINT "Tool_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ToolToRitualRelation" ADD CONSTRAINT "ToolToRitualRelation_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "Ritual"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ToolToRitualRelation" ADD CONSTRAINT "ToolToRitualRelation_toolId_fkey" FOREIGN KEY ("toolId") REFERENCES "Tool"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantPersonToRitualObservanceRelation" ADD CONSTRAINT "ParticipantPersonToRitualObservanceRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipantPersonToRitualObservanceRelation" ADD CONSTRAINT "ParticipantPersonToRitualObservanceRelation_ritualObservan_fkey" FOREIGN KEY ("ritualObservanceId") REFERENCES "RitualObservance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WielderPersonToToolRelation" ADD CONSTRAINT "WielderPersonToToolRelation_personId_ritualObservanceId_fkey" FOREIGN KEY ("personId", "ritualObservanceId") REFERENCES "ParticipantPersonToRitualObservanceRelation"("personId", "ritualObservanceId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WielderPersonToToolRelation" ADD CONSTRAINT "WielderPersonToToolRelation_toolId_ritualId_fkey" FOREIGN KEY ("toolId", "ritualId") REFERENCES "ToolToRitualRelation"("toolId", "ritualId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PersonTarotRoleRelation" ADD CONSTRAINT "PersonTarotRoleRelation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PersonTarotRoleRelation" ADD CONSTRAINT "PersonTarotRoleRelation_tarotReadingId_fkey" FOREIGN KEY ("tarotReadingId") REFERENCES "TarotReading"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotSpread" ADD CONSTRAINT "TarotSpread_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotPosition" ADD CONSTRAINT "TarotPosition_tarotSpreadId_fkey" FOREIGN KEY ("tarotSpreadId") REFERENCES "TarotSpread"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "TarotPosition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_tarotReadingId_fkey" FOREIGN KEY ("tarotReadingId") REFERENCES "TarotReading"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCard" ADD CONSTRAINT "TarotCard_majorArcanaNumberId_fkey" FOREIGN KEY ("majorArcanaNumberId") REFERENCES "MajorArcanaNumber"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCard" ADD CONSTRAINT "TarotCard_rankId_fkey" FOREIGN KEY ("rankId") REFERENCES "TarotRank"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCard" ADD CONSTRAINT "TarotCard_suitId_fkey" FOREIGN KEY ("suitId") REFERENCES "TarotSuit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotSuitAlias" ADD CONSTRAINT "TarotSuitAlias_deckId_fkey" FOREIGN KEY ("deckId") REFERENCES "TarotDeck"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotSuitAlias" ADD CONSTRAINT "TarotSuitAlias_suitId_fkey" FOREIGN KEY ("suitId") REFERENCES "TarotSuit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MajorArcanaAlias" ADD CONSTRAINT "MajorArcanaAlias_deckId_fkey" FOREIGN KEY ("deckId") REFERENCES "TarotDeck"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MajorArcanaAlias" ADD CONSTRAINT "MajorArcanaAlias_numberId_fkey" FOREIGN KEY ("numberId") REFERENCES "MajorArcanaNumber"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeckCard" ADD CONSTRAINT "TarotDeckCard_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "TarotCard"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeckCard" ADD CONSTRAINT "TarotDeckCard_tarotDeckId_fkey" FOREIGN KEY ("tarotDeckId") REFERENCES "TarotDeck"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotDeck" ADD CONSTRAINT "TarotDeck_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReadingToRitualObservanceAndStepRelation" ADD CONSTRAINT "TarotReadingToRitualObservanceAndStepRelation_ritualObserv_fkey" FOREIGN KEY ("ritualObservanceId") REFERENCES "RitualObservance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReadingToRitualObservanceAndStepRelation" ADD CONSTRAINT "TarotReadingToRitualObservanceAndStepRelation_ritualStepId_fkey" FOREIGN KEY ("ritualStepId") REFERENCES "RitualStep"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReadingToRitualObservanceAndStepRelation" ADD CONSTRAINT "TarotReadingToRitualObservanceAndStepRelation_tarotReading_fkey" FOREIGN KEY ("tarotReadingId") REFERENCES "TarotReading"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
