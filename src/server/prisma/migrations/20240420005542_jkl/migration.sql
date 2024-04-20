/*
  Warnings:

  - A unique constraint covering the columns `[personId]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "User" ADD COLUMN     "personId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "User_personId_key" ON "User"("personId");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE SET NULL ON UPDATE CASCADE;
