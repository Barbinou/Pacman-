Game game;
Board board; 

void setup() {
  size(800, 600, P2D);
  game = new Game();
}

void draw() {// deplacer background et gamedrawit dans la fonction draw 
  background(0);
  game.drawIt();
  game.update(); 
  game.handleKey(key);
}

void keyPressed() {
}

void mousePressed() {
}
