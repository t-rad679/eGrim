/*
  Warnings:

  - You are about to drop the column `isSelf` on the `Person` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[selfUserId]` on the table `Person` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,name]` on the table `Person` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Person_name_key";

-- AlterTable
ALTER TABLE "Person" DROP COLUMN "isSelf",
ADD COLUMN     "selfUserId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Person_selfUserId_key" ON "Person"("selfUserId");

-- CreateIndex
CREATE UNIQUE INDEX "Person_userId_name_key" ON "Person"("userId", "name");

-- AddForeignKey
ALTER TABLE "Person" ADD CONSTRAINT "Person_selfUserId_fkey" FOREIGN KEY ("selfUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
