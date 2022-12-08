import processing.sound.*;

Game game;
Board board;
SoundFile frightenedMusic, chaseMusic;

void setup() {
  size(800, 600, P2D);
  game = new Game();
  frightenedMusic = new SoundFile(this, "music/castevania2.wav");
  chaseMusic = new SoundFile(this, "music/Aggresivity_7.wav");
}

void draw() {
  background(0);
  game.drawIt();
  game.update();
  music();
}

void music() { // fonction qui gère la musique 
  switch(game._gameState) { // je regarde en quel mode je suis 
  case "FRIGHTENED":
    if (game._musicF) {
      chaseMusic.stop(); 
      frightenedMusic.stop(); // quand je prolonge mon mode je n'est pas la musique qui se superpose 
      frightenedMusic.play();
      game._musicF = false; 
    }
    break; 
  case "CHASE":
    if(game._musicC){
      frightenedMusic.stop();
      chaseMusic.loop();
      game._musicC = false; 
    }
  }
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
