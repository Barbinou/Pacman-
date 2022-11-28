Game game;
Board board; 

void setup() {
  size(1200, 600, P2D);
  game = new Game();
  game.drawIt();
}

void draw() {// deplacer background et gamedrawit dans la fonction draw
  game.update(); 
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
