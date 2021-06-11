Board board;
float x = 100;
float y = 100;
float w = 400;
float s = w/8;

Button queenButton = new Button(510, 100, 100, 30, "Queen");
Button knightButton = new Button(510, 140, 100, 30, "Knight");

void setup() {
  size(800, 600);
  board = new Board();
}

void draw() {
  background(0);
  textSize(12);
  board.drawThis();
  if (board.elevatePawn != -1) {
    queenButton.drawThis();
    knightButton.drawThis();
  }
  fill(255);
  text(board.enPasse, 50, 50);
  textSize(30);
  if (board.checkMate) {
    text("Schachmatt!", 580, 300);
  } else if (board.check) {
    text("Schach!", 580, 300);
  }
}

class Button {
  float x;
  float y;
  float w;
  float h;
  String label;
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  boolean click() {
    if (mouseX<x || mouseX>x+w || mouseY<y || mouseY>y+h) {
      return false;
    } else {
      return true;
    }
  }
  void drawThis() {
    fill(board.activePlayer==1 ? 200 : 100);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x+w/2, y+h/2);
  }
}

class Board {
  int select = -1;
  int activePlayer = 1;
  int fields[] = new int[100];
  boolean check = false;
  boolean checkMate = false;
  int elevatePawn = -1;
  int enPasse = -1;
  ArrayList<Move> possibleMoves = new ArrayList<Move>();
  Board() {
    setupPieces();
  }
  Board(int activePlayer, int fields[], boolean check, boolean checkMate, int enPasse) {
    this.activePlayer = activePlayer;
    this.fields = fields;
    this.check = check;
    this.checkMate = checkMate;
    this.enPasse = enPasse;
  }
  Board boardAfterMove(Move move) {
    Board res = new Board(activePlayer, fields.clone(), check, checkMate, enPasse);
    res.playMove(move);
    return res;
  }
  void playMove(Move move) {
    //elevate pawn
    if (move.from < 0) {
      fields[-move.from] = move.to;
      elevatePawn = -1;
      activePlayer = -activePlayer;
      return;
    }

    // take out pawn with enPasse
    if (abs(fields[move.from])==6 && enPasse==move.to) {
      if (enPasse/10 == 3) {
        fields[move.to+10] = 0;
      }
      if (enPasse/10 == 6) {
        fields[move.to-10] = 0;
      }
    }
    fields[move.to] = fields[move.from];
    fields[move.from] = 0;
    // if pawns first move
    if (abs(fields[move.to])==6 && abs(move.to-move.from)>11) {
      enPasse = (move.to + move.from) / 2;
    } else {
      enPasse = -1;
    }
    if (abs(fields[move.to])==6 && (move.to/10==1 || move.to/10==8)) {
      elevatePawn = move.to;
    } else {
      activePlayer = -activePlayer;
      check = isCheck();
    }
    //for (int i = 11; i<60; i++) {
    //  if (insideBoard(i) && fields[i] * activePlayer > 0) {
    //    if (possibleMovesPiece(i).size()>0) {
    //      return;
    //    }
    //  }
    //}
  }
  boolean isCheck() {
    Board nextBoard = new Board(-activePlayer, fields, false, false, enPasse);
    ArrayList<Move> possMoves = nextBoard.possibleMovesNoCheck();
    for (Move m : possMoves) {
      println(m);
      if (abs(fields[m.to])==1) {
        return true;
      }
    }
    return false;
  }
  void setupPieces() {
    for (int i = 0; i<fields.length; i++) {
      fields[i] = 0;
    }

    // black
    for (int i = 0; i<8; i++) {
      int row = 10;
      fields[row + 1] = -3;
      fields[row + 2] = -4;
      fields[row + 3] = -5;
      fields[row + 4] = -2;
      fields[row + 5] = -1;
      fields[row + 6] = -5;
      fields[row + 7] = -4;
      fields[row + 8] = -3;
    }
    for (int i = 21; i<30; i++) {
      fields[i] = -6;
    }

    // white
    for (int i = 0; i<8; i++) {
      int row = 80;
      fields[row + 1] = 3;
      fields[row + 2] = 4;
      fields[row + 3] = 5;
      fields[row + 4] = 2;
      fields[row + 5] = 1;
      fields[row + 6] = 5;
      fields[row + 7] = 4;
      fields[row + 8] = 3;
    }
    for (int i = 71; i<80; i++) {
      fields[i] = 6;
    }
  }
  void drawPossMoves() {
    for (Move m : possibleMoves) {
      float _x = x + (m.to % 10 - 0.5) * s;
      float _y = y + (m.to / 10 - 0.5) * s;
      fill(200, 200, 0);
      circle(_x, _y, s*0.5);
    }
  }
  void drawThis() {
    noStroke();
    for (int i = 0; i<64; i++) {
      if ((i+i/8) % 2 == 0) {
        fill(150);
      } else {
        fill(80);
      }
      float _x = x + i % 8 * s;
      float _y = y + i / 8 * s;
      rect(_x, _y, s, s);
      if (select == i) {
        drawSelectMarker(_x + s/2, _y + s/2, s*0.9);
      }
    }
    drawPossMoves();
    for (int i = 0; i<64; i++) {
      float _x = x + i % 8 * s;
      float _y = y + i / 8 * s;
      drawPiece(_x, _y, s, i);
    }
  }
  int getIndex(int num) {
    int col = num % 8;
    int row = num / 8;
    return getIndex(col, row);
  }
  int getIndex(int col, int row) {
    return (10 * (1 + row)) + (col + 1);
  }
  void drawPiece(float _x, float _y, float s, int field) {
    int ind = getIndex(field);
    textAlign(CENTER, CENTER);
    if (fields[ind] > 0) {
      fill(255);
    } else {
      fill(0);
    }
    String name = "";
    switch(abs(fields[ind])) {
    case 0:
      break;
    case 1: 
      name = "King";
      break;
    case 2: 
      name = "Queen";
      break;
    case 3: 
      name = "Rook";
      break;
    case 4: 
      name = "Knight";
      break;
    case 5: 
      name = "Bishop";
      break;
    case 6: 
      name = "Pawn";
      break;
    }
    text(name, _x + s/2, _y + s/2);
  }
  void drawSelectMarker(float x, float y, float d) {
    noStroke();
    fill(50);
    circle(x, y, d);
  }
  void click() {
    if (elevatePawn != -1) {
      if (queenButton.click()) {
        playMove(new Move(-elevatePawn, 2));
      }
      if (knightButton.click()) {
        playMove(new Move(-elevatePawn, 4));
      }
      return;
    }
    if (mouseX < x || mouseX > x+w || mouseY < y || mouseY > y+w) {
      select = -1;
      possibleMoves.clear();
      return;
    }
    int col = (int)((mouseX - x) / s);
    int row = (int)((mouseY - y) / s);
    int clickedField = col + 8*row;
    int ind = getIndex(clickedField);
    if ((fields[ind] * activePlayer <= 0) && select!=-1) {
      Move move = new Move(getIndex(select), ind);
      if (moveIsPossible(move)) {
        playMove(move);
        if (possibleMoves().size()==0) {
          if (check) {
            checkMate = true;
          }
        }
      }
      select = -1;
      possibleMoves.clear();
    } else {
      if (fields[ind] * activePlayer > 0) {
        select = clickedField;
        possibleMoves = possibleMovesPiece(getIndex(select));
      }
    }
  }
  boolean moveIsPossible(Move move) {
    for (Move m : possibleMoves) {
      if (m.from == move.from && m.to == move.to) {
        return true;
      }
    }
    return false;
  }
  void addDirection(int ind, int dir, int player, ArrayList<Move> res) {
    int _ind = ind+dir;
    while (insideBoard(_ind)) {
      if (fields[_ind] * player <= 0) {
        res.add(new Move(ind, _ind));
        if (fields[_ind] != 0) {
          break;
        }
        _ind = _ind+dir;
        if (!insideBoard(_ind)) {
          break;
        }
      } else {
        break;
      }
    }
  }
  ArrayList<Move> possibleMovesPieceNoCheck(int ind) {
    int player = fields[ind] > 0 ? 1 : -1;
    ArrayList<Move> res = new ArrayList<Move>();
    if (fields[ind] == 0) {
      return res;
    }
    // White Pawn
    else if (fields[ind] == 6) {
      if (fields[ind-11]<0 || enPasse == ind-11) {
        res.add(new Move(ind, ind-11));
      }
      if (fields[ind-9]<0 || enPasse == ind-9) {
        res.add(new Move(ind, ind-9));
      }
      if (fields[ind-10]==0) {
        res.add(new Move(ind, ind-10));
      }
      if (ind / 10 == 7 && fields[ind-20]==0) {
        res.add(new Move(ind, ind-20));
      }
    }
    // Black Pawn
    else if (fields[ind] == -6) {
      if (fields[ind+11]>0 || enPasse == ind+11) {
        res.add(new Move(ind, ind+11));
      }
      if (fields[ind+9]>0 || enPasse == ind+9) {
        res.add(new Move(ind, ind+9));
      }
      if (fields[ind+10]==0) {
        res.add(new Move(ind, ind+10));
      }
      if (ind / 10 == 2 && (fields[ind+20]==0)) {
        res.add(new Move(ind, ind+20));
      }
    }
    // King
    else if (abs(fields[ind]) == 1) {
      if (insideBoard(ind-11) && fields[ind-11] * player <= 0) {
        res.add(new Move(ind, ind-11));
      }
      if (insideBoard(ind-10) && fields[ind-10] * player <= 0) {
        res.add(new Move(ind, ind-10));
      }
      if (insideBoard(ind-9) && fields[ind-9] * player <= 0) {
        res.add(new Move(ind, ind-9));
      }
      if (insideBoard(ind-1) && fields[ind-1] * player <= 0) {
        res.add(new Move(ind, ind-1));
      }
      if (insideBoard(ind+1) && fields[ind+1] * player <= 0) {
        res.add(new Move(ind, ind+1));
      }
      if (insideBoard(ind+9) && fields[ind+9] * player <= 0) {
        res.add(new Move(ind, ind+9));
      }
      if (insideBoard(ind+10) && fields[ind+10] * player <= 0) {
        res.add(new Move(ind, ind+10));
      }
      if (insideBoard(ind+11) && fields[ind+11] * player <= 0) {
        res.add(new Move(ind, ind+11));
      }
    }
    // Queen
    else if (abs(fields[ind]) == 2) {
      addDirection(ind, -11, player, res);
      addDirection(ind, -10, player, res);
      addDirection(ind, -9, player, res);
      addDirection(ind, -1, player, res);
      addDirection(ind, 1, player, res);
      addDirection(ind, 9, player, res);
      addDirection(ind, 10, player, res);
      addDirection(ind, 11, player, res);
    }
    // Rook
    else if (abs(fields[ind]) == 3) {
      addDirection(ind, -10, player, res);
      addDirection(ind, -1, player, res);
      addDirection(ind, 1, player, res);
      addDirection(ind, 10, player, res);
    }
    // Knight
    else if (abs(fields[ind]) == 4) {
      if (insideBoard(ind-21) && fields[ind-21]*activePlayer <= 0) res.add(new Move(ind, ind-21));
      if (insideBoard(ind-19) && fields[ind-19]*activePlayer <= 0) res.add(new Move(ind, ind-19));
      if (insideBoard(ind-12) && fields[ind-12]*activePlayer <= 0) res.add(new Move(ind, ind-12));
      if (insideBoard(ind-8) && fields[ind-8]*activePlayer <= 0) res.add(new Move(ind, ind-8));
      if (insideBoard(ind+8) && fields[ind+8]*activePlayer <= 0) res.add(new Move(ind, ind+8));
      if (insideBoard(ind+12) && fields[ind+12]*activePlayer <= 0) res.add(new Move(ind, ind+12));
      if (insideBoard(ind+19) && fields[ind+19]*activePlayer <= 0) res.add(new Move(ind, ind+19));
      if (insideBoard(ind+21) && fields[ind+21]*activePlayer <= 0) res.add(new Move(ind, ind+21));
    }
    // Bishop
    else if (abs(fields[ind]) == 5) {
      addDirection(ind, -11, player, res);
      addDirection(ind, -9, player, res);
      addDirection(ind, 9, player, res);
      addDirection(ind, 11, player, res);
    }
    return res;
  }
  ArrayList<Move> possibleMovesPiece(int ind) {
    ArrayList<Move> res = possibleMovesPieceNoCheck(ind);
    int i = 0;
    while (i < res.size()) {
      Board nextBoard = boardAfterMove(res.get(i));
      nextBoard.activePlayer *= -1;
      if (nextBoard.isCheck()) {
        res.remove(i);
      } else {
        i++;
      }
    }
    return res;
  }
  ArrayList<Move> possibleMovesNoCheck() {
    ArrayList<Move> res = new ArrayList<Move>();
    if (elevatePawn != -1) {
      res.add(new Move(-elevatePawn, 2));
      res.add(new Move(-elevatePawn, 4));
      return res;
    }
    for (int i = 1; i<9; i++) {
      for (int j = 1; j<9; j++) {
        if (fields[i + j*10] * activePlayer > 0) {
          res.addAll(possibleMovesPieceNoCheck(i + j*10));
        }
      }
    }
    return res;
  }
  ArrayList<Move> possibleMoves() {
    ArrayList<Move> res = possibleMovesNoCheck();
    int i = 0;
    while (i < res.size()) {
      if (boardAfterMove(res.get(i)).isCheck()) {
        res.remove(i);
      } else {
        i++;
      }
    }
    return res;
  }

  boolean insideBoard(int ind) {
    return !(ind < 10 || ind >= 90 || ind%10 == 0 || ind%10 == 9);
  }
}

void mousePressed() {
  board.click();
}

class Move {
  // negative value for elevate pawn
  int from;
  int to;
  Move(int from, int to) {
    this.from = from;
    this.to = to;
  }
  String toString() {
    return  "Move: " + from + " / " + to;
  }
}
