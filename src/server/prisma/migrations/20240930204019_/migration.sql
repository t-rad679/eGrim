/*
  Warnings:

  - The primary key for the `PersonTarotRoleRelation` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `description` on the `TarotSpread` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[tarotSpreadId,number]` on the table `TarotPosition` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,name]` on the table `TarotSpread` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `cardId` to the `TarotCardDraw` table without a default value. This is not possible if the table is not empty.
  - Added the required column `deckId` to the `TarotReading` table without a default value. This is not possible if the table is not empty.
  - Added the required column `spreadId` to the `TarotReading` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Event" ALTER COLUMN "description" DROP NOT NULL;

-- AlterTable
ALTER TABLE "PersonTarotRoleRelation" DROP CONSTRAINT "PersonTarotRoleRelation_pkey",
ADD CONSTRAINT "PersonTarotRoleRelation_pkey" PRIMARY KEY ("personId", "tarotReadingId");

-- AlterTable
ALTER TABLE "RitualStep" ALTER COLUMN "description" DROP NOT NULL;

-- AlterTable
ALTER TABLE "TarotCardDraw" ADD COLUMN     "cardId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "TarotPosition" ALTER COLUMN "description" DROP NOT NULL;

-- AlterTable
ALTER TABLE "TarotReading" ADD COLUMN     "deckId" TEXT NOT NULL,
ADD COLUMN     "spreadId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "TarotSpread" DROP COLUMN "description",
ADD COLUMN     "notes" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "TarotPosition_tarotSpreadId_number_key" ON "TarotPosition"("tarotSpreadId", "number");

-- CreateIndex
CREATE UNIQUE INDEX "TarotSpread_userId_name_key" ON "TarotSpread"("userId", "name");

-- AddForeignKey
ALTER TABLE "TarotReading" ADD CONSTRAINT "TarotReading_deckId_fkey" FOREIGN KEY ("deckId") REFERENCES "TarotDeck"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotReading" ADD CONSTRAINT "TarotReading_spreadId_fkey" FOREIGN KEY ("spreadId") REFERENCES "TarotSpread"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "TarotDeckCard"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
