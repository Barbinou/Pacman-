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
  case FRIGHTENED:
    if (_game._musicF && !_game._gamePaused) {
      chaseMusic.stop();
      // lorsque le mode est prolongé la musique ne se superpose pas
      frightenedMusic.stop();
      frightenedMusic.play();
      // _game._musicF permet de pas relire à chaque frame la musique
      _game._musicF = false;
    } else if (_game._gamePaused) {
      frightenedMusic.stop();
      _game._musicF = true;
    }
    break;
  case CHASE:
    if (_game._musicC && !_game._gamePaused) {
      frightenedMusic.stop();
      chaseMusic.loop();
      //regle le volume de la musique
      chaseMusic.amp(0.7);
      _game._musicC = false;
    } else if (_game._gamePaused) {
      chaseMusic.stop();
      _game._musicC = true;
    }
    break;
  case END:
    frightenedMusic.stop();
    chaseMusic.stop();
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
  // Si la touche pressée n'est pas BACKSPACE et que la longueur du pseudo est inférieure à 3
  // la touche pressée est une lettre de l'alphabet en minuscule
  else if (keyCode != BACKSPACE && _game._menu._pseudo.length() < 3 && key >= LETTER_A && key <= LETTER_Z) {
    _game._menu._pseudo += key;
  }
  // Sinon, si la touche pressée est BACKSPACE et que la longueur du pseudo est supérieure à 0
  else if (keyCode == BACKSPACE && _game._menu._pseudo.length() > 0) {
    _game._menu._pseudo = _game._menu._pseudo.substring(0, _game._menu._pseudo.length() - 1);
  }
  _game.handleKey(key);
}
