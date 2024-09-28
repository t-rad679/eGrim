-- DropForeignKey
ALTER TABLE "TarotCard" DROP CONSTRAINT "TarotCard_suitId_fkey";

-- AlterTable
ALTER TABLE "TarotCard" ALTER COLUMN "suitId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "TarotCard" ADD CONSTRAINT "TarotCard_suitId_fkey" FOREIGN KEY ("suitId") REFERENCES "TarotSuit"("id") ON DELETE SET NULL ON UPDATE CASCADE;
