HashMap<Integer, String> cardNames = new HashMap<Integer, String>();

void setCardNames() {
  cardNames.put(1, "A");
  cardNames.put(2, "2");
  cardNames.put(3, "3");
  cardNames.put(4, "4");
  cardNames.put(5, "5");
  cardNames.put(6, "6");
  cardNames.put(7, "7");
  cardNames.put(8, "8");
  cardNames.put(9, "9");
  cardNames.put(10, "10");
  cardNames.put(11, "J");
  cardNames.put(12, "Q");
  cardNames.put(13, "K");
}

class Card {
  int value;
  int colour;
  Card(int value, int colour) {
    this.value = value;
    this.colour = colour;
  }
  public int compareTo(Object o) {
    return value - ((Card)o).value;
  }
}

int getScore(ArrayList<Card> hand) {
  int score = 0;
  int aces = 0;
  for (Card c : hand) {
    if (c.value == 1) {
      aces++;
      score += 11;
    } else {
      score += constrain(c.value, 2, 10);
    }
  }
  for (int i = 0; i<aces; i++) {
    if (score>21) {
      score -= 10;
    }
  }
  if(score==21 && hand.size()==2) {
    score = 100;
  }
  return score;
}
