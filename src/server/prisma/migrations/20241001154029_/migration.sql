/*
  Warnings:

  - You are about to drop the column `notes` on the `TarotSpread` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "TarotSpread" DROP COLUMN "notes",
ADD COLUMN     "description" TEXT;
