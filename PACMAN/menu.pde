import java.io.BufferedWriter;
import java.io.FileWriter;

class Menu {

  Blinky _blinky;
  Clyde _clyde;
  Inky _inky;
  Pinky _pinky;

  float _backgroundPosX, _backgroundPosY, _time;

  Menu(Game g, Board b) {
    _game = g;
    _board = b;
    _backgroundPosX = width*0.5;
    _backgroundPosY = height*0.5;
    _time = millis(); // enregistre le temps passé avant l'apparition du menu
  }

  Menu(Game g, Board b, float t) { // overload du constructeur pour la gestion de la second pause et plus 
    _game = g;
    _board = b;
    _backgroundPosX = width*0.5;
    _backgroundPosY = height*0.5;
    _time = t;
  }

  void drawIt() {
    drawBackground();
    drawCases();
  }

  void drawBackground() { // dessine le background noir et jaune
    rectMode(CORNER);
    fill(BLACK);
    rect(0, height*0.09, width, height);
    rectMode(CORNER);
    fill(YELLOW);
    rect(width * 0.1, height*0.2, width*0.8, height*0.7, ARRONDI);
  }

  void drawCases() { // dessine les cases
    rectMode(CENTER);
    int j = 0;
    for (float i = 0.6; i <= 1.6; i += 0.25) {
      hitboxCase(i, j);
      rect(_backgroundPosX, _backgroundPosY*i, _backgroundPosX, _backgroundPosY / 6, ARRONDI);
      textAlign(CENTER, CENTER);
      fill(WHITE);
      text(MENU[j], _backgroundPosX, _backgroundPosY*i);
      j++;
    }
  }

  void optionMenu(int j) {
    switch(MENU[j]) {
    case "Sauvegarder":
      if (mouseButton == LEFT && mousePressed) {
        try {
          BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + "/data/save.txt")); // creattion du fichier save.txt 
          _board.saveBoard(writer);
          _game.saveGame(writer);
          writer.close(); // fermeture du fichier 
        }
        catch (IOException e) {
          e.printStackTrace();
        }
        endPause();
      }
      break;
    case "Charger":
      //code Charger
      break;
    case "Recommencer":
      if (mouseButton == LEFT && mousePressed) {
        mousePressed = false;  // permet de ne plus enregistrer la touche comme appuyé 
        _game = new Game(path.getAbsolutePath());
        _game._menu._time = millis();  // garde en mémoire le reset
        _game._timeNoPause = millis();  // permet de remettre les conditions de sortie au débuts
        _game._gameRetry = true;
      }
      break;
    case "Highscores":
      // code highscore
      break;
    case "Quitter":
      if (mouseButton == LEFT && mousePressed) {
        exit();
      }
      break;
    }
  }

  void endPause() { // fonction qui fini la pause
    _game._gamePaused = false;
    _game._timeNoPause = (millis() - _time); // correpsond au temps écoule depuis le lancement du programme - le temps depuis le depuis de la pause
    _game._menu._time = millis() - _game._timeNoPause; // correpsond au temps en sortie du menu
  }

  void hitboxCase(float i, int j) { // fonction qui gere les fonctionalités de mon menu 
    if (mouseY >= (_backgroundPosY*i) - _backgroundPosY / 12 && mouseY <= (_backgroundPosY*i)+ _backgroundPosY / 12 && mouseX <= _backgroundPosX + _backgroundPosX *0.5 && mouseX >= _backgroundPosX - _backgroundPosX *0.5 ) { // si je suis sur la case
      fill(RED);
      optionMenu(j);
    } else {
      fill(BLUE);
      if (mouseButton == LEFT && mousePressed) { // si je clique n'importe ou en dehors des cases je reviens au jeu 
        endPause();
      }
    }
  }
}
