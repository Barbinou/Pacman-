Game game;
Board board; 

void setup() {
  size(800, 800, P2D);
  game = new Game();
  board = new Board(POSITION, NB_CELLS_X, NB_CELLS_Y, CELL_SIZE); 
  board.drawIt();
}

void draw() {
  game.update();
  game.drawIt(); 
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
