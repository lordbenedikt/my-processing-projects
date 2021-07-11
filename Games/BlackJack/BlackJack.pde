import java.util.Collections;

ArrayList<Card> hands[];
ArrayList<Card> dealerHand = new ArrayList<Card>();
ArrayList<Card> deck = new ArrayList<Card>();
ArrayList<Card> discardPile = new ArrayList<Card>();
int currentPlayer;
int playerStates[];
int playerCount;
int totalCards;
boolean gameOver = false;

void setup() {
  size(800, 600);
  setCardNames();
  setStates();
  reset(1);
}

void draw() {
  background(100);
  drawPlyStats(dealerHand, 100);
  drawAllPlyStats(hands);
  drawStats();
}

void drawStats() {
  text("Cards in discard pile:    " + discardPile.size(), 500, 50);
  text("Cards in draw pile:    " + deck.size(), 500, 70);
  int cards[] = new int[13];
  for (Card c : deck) {
    cards[c.value-1]++;
  }
  for (int i = 1; i<=13; i++) {
    if((i-1)%2==0) fill(0);
    else fill(255,0,0);
    text(cardNames.get(i), 500+(i-1)*20, 100);
    fill(255);
    text(cards[i-1], 500+(i-1)*20, 115);
  }
  float permille = round((float)(cards[9] + cards[11] + cards[12] + cards[12])/deck.size()*1000);
  text("Percentage face cards/tens:  " + (permille/10) + "%  (average=30.8%)", 500, 140);
}

void hit(int player) {
  if (!gameOver) {
    shuffleIfNecessary();
    if (currentPlayer<playerCount) {
      hands[player].add(deck.get(deck.size()-1));
      deck.remove(deck.size()-1);
      if (getScore(hands[currentPlayer])>21 && hands[currentPlayer].size()!=2) {
        playerStates[currentPlayer] = -2;
        currentPlayer++;
      }
    } else {
      dealerHit();
      if (getScore(dealerHand)>=17) {
        gameOver();
      }
    }
  }
}


void gameOver() {
  gameOver = true;
  int dealerScore = getScore(dealerHand);
  for (int i = 0; i<hands.length; i++) {
    int score = getScore(hands[i]);
    if (score>21 && score!=100) {
      playerStates[i] = -2;
    } else if (score>dealerScore) {
      playerStates[i] = 1;
    } else if (score==dealerScore) {
      playerStates[i] = 0;
    } else if (score<dealerScore) {
      if (dealerScore>21) {
        playerStates[i] = 1;
      } else {
        playerStates[i] = -1;
      }
    }
  }
}

void dealerHit() {
  shuffleIfNecessary();
  dealerHand.add(deck.get(deck.size()-1));
  deck.remove(deck.size()-1);
}

void shuffleIfNecessary() {
  if (deck.size()<=52) {
    shuffleDeck();
  }
}

void hold() {
}

void reset(int players) {
  playerCount = players;
  initializeDeck();
  clearTable();
  discardPile.clear();
  shuffleDeck();
  nextRound();
}

void nextRound() {
  gameOver = false;
  currentPlayer = 0;
  clearTable();
  // initialize player states
  playerStates = new int[playerCount];
  dealerHit();
}

void clearTable() {
  discardPile.addAll(dealerHand);
  dealerHand.clear();
  for (ArrayList<Card> hand : hands) {
    discardPile.addAll(hand);
    hand.clear();
  }
}

void initializeDeck() {
  deck.clear();
  // initialize player hands
  hands = new ArrayList[playerCount];
  for (int i = 0; i<hands.length; i++) {
    hands[i] = new ArrayList<Card>();
  }
  for (int numOfDecks = 0; numOfDecks<2; numOfDecks++) {
    for (int i = 1; i<=13; i++) {
      for (int j = 0; j<4; j++) {
        deck.add(new Card(i, j));
      }
    }
  }
  totalCards = deck.size();
}

void shuffleDeck() {
  deck.addAll(discardPile);
  discardPile.clear();
  Collections.shuffle(deck);
}
