Game game;
Board board; 

void setup() {
  size(800, 800, P2D);
  game = new Game();
  game.drawIt();
}

void draw() {
  game.update(); 
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
