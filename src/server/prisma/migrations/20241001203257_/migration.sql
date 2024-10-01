/*
  Warnings:

  - The primary key for the `PersonTarotRoleRelation` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `dummy` on the `TarotReading` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "TarotCardDraw" DROP CONSTRAINT "TarotCardDraw_positionId_fkey";

-- AlterTable
ALTER TABLE "PersonTarotRoleRelation" DROP CONSTRAINT "PersonTarotRoleRelation_pkey",
ADD CONSTRAINT "PersonTarotRoleRelation_pkey" PRIMARY KEY ("personId", "role", "tarotReadingId");

-- AlterTable
ALTER TABLE "TarotCardDraw" ADD COLUMN     "clarification" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "positionId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "TarotReading" DROP COLUMN "dummy",
ADD COLUMN     "interpretation" TEXT;

-- AddForeignKey
ALTER TABLE "TarotCardDraw" ADD CONSTRAINT "TarotCardDraw_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "TarotPosition"("id") ON DELETE SET NULL ON UPDATE CASCADE;
