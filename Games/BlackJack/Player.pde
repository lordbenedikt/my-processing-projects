HashMap<Integer, String> states = new HashMap<Integer, String>();

void setStates() {
  states.put(0, "");
  states.put(1, "Win");
  states.put(-1, "Lose");
  states.put(-2, "Bust");
}

void drawPlyStats(ArrayList<Card> hand, int y) {
  int score = getScore(hand);
  text(score==100 ? "Natural 21" : "" + score, 100, y-15);
  for(int i = 0; i<hand.size(); i++) {
    text(cardNames.get(hand.get(i).value), 100+i*20, y);
  }
}

void drawAllPlyStats(ArrayList[] hands) {
  for(int i = 0; i< hands.length; i++) {
    text(states.get(playerStates[i]), 50, 200+i*100);
    drawPlyStats(hands[i], 200+i*100);
  }
}
