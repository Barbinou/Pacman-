Game game;
Board board; 

void setup() {
  size(600, 600, P2D);
  game = new Game();
}

void draw() {
  background(0);// deplacer background et gamedrawit dans la fonction draw
  game.drawIt();
  game.update(); 
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
