import processing.sound.*;

Game _game;
Board _board;
SoundFile frightenedMusic, chaseMusic;
File path;

void setup() {
  size(800, 600, P2D); 
  frightenedMusic = new SoundFile(this, "music/castevania2.wav"); // creation des musiques 
  chaseMusic = new SoundFile(this, "music/Aggresivity_7.wav");
  path = new File(sketchPath("")); // creation d'un objet file pour pouvoir avoir le chemin absolu 
  _game = new Game(path.getAbsolutePath()); // permet d'obtenir le chemin absolu pour enregister mon fichier 
}

void draw() {
  background(0);
  _game.drawIt();
  _game.update();
  music();
}

void music() { // fonction qui gère la musique
  switch(_game._gameState) { // je regarde en quel mode je suis
  case "FRIGHTENED":
    if (_game._musicF && !_game._gamePaused) {
      chaseMusic.stop();
      frightenedMusic.stop(); // quand je prolonge mon mode je n'est pas la musique qui se superpose
      frightenedMusic.play();
      _game._musicF = false;
    } else if (_game._gamePaused) {
      frightenedMusic.stop();
      _game._musicF = true;
    }
    break;
  case "CHASE":
    if (_game._musicC && !_game._gamePaused) {
      frightenedMusic.stop();
      chaseMusic.loop();
      chaseMusic.amp(0.7);
      _game._musicC = false;
    } else if (_game._gamePaused) {
      chaseMusic.stop();
      _game._musicC = true;
    }
  }
}

void keyPressed() {
  if (key == ESC && keyPressed) {
    key = 0;
    if (_game._gameRetry) { // si je recommence la partie 
      _game._gameRetry = false;
      _game._menu._time = millis(); // je reiniialise le time menu 
    }
    _game._gamePaused = true;
    _game._menu._time = millis() - _game._timeNoPause; // je conserve le temps du menu 
  }
  _game.handleKey(key);
}
