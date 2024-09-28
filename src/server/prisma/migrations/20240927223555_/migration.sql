/*
  Warnings:

  - You are about to drop the column `majorArcanaNumberId` on the `TarotCard` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `TarotCard` table. All the data in the column will be lost.
  - You are about to drop the `MajorArcanaNumber` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[majorArcanaInfoId,rankId,suitId]` on the table `TarotCard` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "MajorArcanaAlias" DROP CONSTRAINT "MajorArcanaAlias_numberId_fkey";

-- DropForeignKey
ALTER TABLE "TarotCard" DROP CONSTRAINT "TarotCard_majorArcanaNumberId_fkey";

-- DropIndex
DROP INDEX "TarotCard_majorArcanaNumberId_rankId_suitId_key";

-- AlterTable
ALTER TABLE "TarotCard" DROP COLUMN "majorArcanaNumberId",
DROP COLUMN "name",
ADD COLUMN     "majorArcanaInfoId" TEXT;

-- DropTable
DROP TABLE "MajorArcanaNumber";

-- CreateTable
CREATE TABLE "MajorArcanaInfo" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "number" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "MajorArcanaInfo_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MajorArcanaInfo_number_key" ON "MajorArcanaInfo"("number");

-- CreateIndex
CREATE UNIQUE INDEX "MajorArcanaInfo_name_key" ON "MajorArcanaInfo"("name");

-- CreateIndex
CREATE UNIQUE INDEX "TarotCard_majorArcanaInfoId_rankId_suitId_key" ON "TarotCard"("majorArcanaInfoId", "rankId", "suitId");

-- AddForeignKey
ALTER TABLE "TarotCard" ADD CONSTRAINT "TarotCard_majorArcanaInfoId_fkey" FOREIGN KEY ("majorArcanaInfoId") REFERENCES "MajorArcanaInfo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MajorArcanaAlias" ADD CONSTRAINT "MajorArcanaAlias_numberId_fkey" FOREIGN KEY ("numberId") REFERENCES "MajorArcanaInfo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
