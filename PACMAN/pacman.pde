Game game;
Board board; 

void setup() {
  size(800, 600, P2D);
  game = new Game();
}

void draw() {
  background(0);
  game.drawIt();
  game.update(); 
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
