/*
  Warnings:

  - A unique constraint covering the columns `[userId,name]` on the table `TarotDeck` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[cardId,tarotDeckId]` on the table `TarotDeckCard` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "TarotDeck_userId_name_key" ON "TarotDeck"("userId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "TarotDeckCard_cardId_tarotDeckId_key" ON "TarotDeckCard"("cardId", "tarotDeckId");
