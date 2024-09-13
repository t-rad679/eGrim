/*
  Warnings:

  - A unique constraint covering the columns `[userId,name]` on the table `Location` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[tagId,eventId,locationId,personId,ritualResultsId,tarotCardId,tarotCardDrawId,tarotDeckId,tarotDeckCardId,tarotPositionId,toolId,tarotSpreadId]` on the table `TagToObjectRelation` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Location_name_key";

-- AlterTable
ALTER TABLE "Location" ADD COLUMN     "zip" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Location_userId_name_key" ON "Location"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "TagToObjectRelation_tagId_eventId_locationId_personId_ritua_key" ON "TagToObjectRelation"("tagId", "eventId", "locationId", "personId", "ritualResultsId", "tarotCardId", "tarotCardDrawId", "tarotDeckId", "tarotDeckCardId", "tarotPositionId", "toolId", "tarotSpreadId");
