/*
  Warnings:

  - You are about to drop the column `numberId` on the `MajorArcanaAlias` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[deckId,majorArcanaInfoId]` on the table `MajorArcanaAlias` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `majorArcanaInfoId` to the `MajorArcanaAlias` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "MajorArcanaAlias" DROP CONSTRAINT "MajorArcanaAlias_numberId_fkey";

-- DropIndex
DROP INDEX "MajorArcanaAlias_deckId_numberId_key";

-- AlterTable
ALTER TABLE "MajorArcanaAlias" DROP COLUMN "numberId",
ADD COLUMN     "majorArcanaInfoId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "MajorArcanaAlias_deckId_majorArcanaInfoId_key" ON "MajorArcanaAlias"("deckId", "majorArcanaInfoId");

-- AddForeignKey
ALTER TABLE "MajorArcanaAlias" ADD CONSTRAINT "MajorArcanaAlias_majorArcanaInfoId_fkey" FOREIGN KEY ("majorArcanaInfoId") REFERENCES "MajorArcanaInfo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
