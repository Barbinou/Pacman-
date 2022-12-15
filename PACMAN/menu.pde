import java.io.BufferedWriter;
import java.io.FileWriter;

public enum TypeSave {
  HERO ("_hero._position.x"),
    BLINKY ("_blinky._position.x"),
    INKY ("_inky._position.x"),
    PINKY ("_pinky._position.x"),
    CLYDE ("_clyde._position.x"),
    GAME ("_game._gameState");

  final String TYPESAVE;

  TypeSave(String typesave) {  // constructeur
    TYPESAVE = typesave;
  }

  String getType() {
    return TYPESAVE;
  }
}

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
          BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + "/data/boardSave.txt")); // creattion du fichier save.txt
          _board.saveBoard(writer);
          writer.close(); // fermeture du fichier
        }
        catch (IOException e) {
          e.printStackTrace();
        }

        try {
          BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + "/data/Save.txt")); // creattion du fichier save.txt
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
      if (mouseButton == LEFT && mousePressed) {

        mousePressed = false;
        String boardSave [] = loadStrings("boardSave.txt"); // charge la sauvegarde
        String gameSave [] = loadStrings("save.txt"); // charge la sauvegarde
        String gameSaveBoard [] = new String [_game._board._nbCellsX];

        Board board;
        Hero hero;
        Blinky blinky;
        Inky inky;
        Pinky pinky;
        Clyde clyde;

        for (int i = 1; i < 23; i++) {
          gameSaveBoard[i] = boardSave[i];
        }

        board = new Board(gameSaveBoard);
        hero = new Hero(board);

        for (int i = 1; i < gameSave.length; i++) {
          gameSave[i] = gameSave[i].replace(',', '.');
          switch (split(gameSave[i], " ")[0]) {
          case "_hero._position.x": // changer par un enum
            hero._position.x = Float.parseFloat(split(gameSave[i], " ")[1]);
            hero._position.y = Float.parseFloat(split(gameSave[i], " ")[3]);
            hero._direction.x = Float.parseFloat(split(gameSave[i], " ")[5]);
            hero._direction.y = Float.parseFloat(split(gameSave[i], " ")[7]);
            hero._overpowered = Boolean.parseBoolean(split(gameSave[i], " ")[9]);
            hero._life = Integer.parseInt(split(gameSave[i], " ")[11]);
            hero._score = Integer.parseInt(split(gameSave[i], " ")[13]);
            hero._cacheLifeUp = Integer.parseInt(split(gameSave[i], " ")[15]);
            hero._move = Integer.parseInt(split(gameSave[i], " ")[17]);
            hero._cacheMove = Integer.parseInt(split(gameSave[i], " ")[19]);
            hero._cellX = Integer.parseInt(split(gameSave[i], " ")[21]);
            hero._cellY = Integer.parseInt(split(gameSave[i], " ")[23]);
            break;
          case "_blinky._position.x":
            println(Integer.parseInt(split(gameSave[i], " ")[17])); 
              _blinky = new Blinky(board, hero, new PVector(Float.parseFloat(split(gameSave[i], " ")[1]), Float.parseFloat(split(gameSave[i], " ")[3])), Boolean.parseBoolean(split(gameSave[i], " ")[5]), Integer.parseInt(split(gameSave[i], " ")[7]), Integer.parseInt(split(gameSave[i], " ")[9]), new PVector(Float.parseFloat(split(gameSave[i], " ")[11]), Float.parseFloat(split(gameSave[i], " ")[13])), Integer.parseInt(split(gameSave[i], " ")[15]), Integer.parseInt(split(gameSave[i], " ")[17]), Integer.parseInt(split(gameSave[i], " ")[19]), Integer.parseInt(split(gameSave[i], " ")[21]));
            break;
          case "_inky._position.x":
            _inky = new Inky(board, hero, new PVector(Float.parseFloat(split(gameSave[i], " ")[1]), Float.parseFloat(split(gameSave[i], " ")[3])), Boolean.parseBoolean(split(gameSave[i], " ")[5]), Integer.parseInt(split(gameSave[i], " ")[7]), Integer.parseInt(split(gameSave[i], " ")[9]), new PVector(Float.parseFloat(split(gameSave[i], " ")[11]), Float.parseFloat(split(gameSave[i], " ")[13])), Integer.parseInt(split(gameSave[i], " ")[15]), Integer.parseInt(split(gameSave[i], " ")[17]), Integer.parseInt(split(gameSave[i], " ")[19]), Integer.parseInt(split(gameSave[i], " ")[21]), Boolean.parseBoolean(split(gameSave[i], " ")[23]));
            break;
          case "_pinky._position.x":
            _pinky = new Pinky(board, hero, new PVector(Float.parseFloat(split(gameSave[i], " ")[1]), Float.parseFloat(split(gameSave[i], " ")[3])), Boolean.parseBoolean(split(gameSave[i], " ")[5]), Integer.parseInt(split(gameSave[i], " ")[7]), Integer.parseInt(split(gameSave[i], " ")[9]), new PVector(Float.parseFloat(split(gameSave[i], " ")[11]), Float.parseFloat(split(gameSave[i], " ")[13])), Integer.parseInt(split(gameSave[i], " ")[15]), Integer.parseInt(split(gameSave[i], " ")[17]), Integer.parseInt(split(gameSave[i], " ")[19]), Integer.parseInt(split(gameSave[i], " ")[21]), Boolean.parseBoolean(split(gameSave[i], " ")[23]));
            break;
          case "_clyde._position.x":
            _clyde = new Clyde(board, hero, new PVector(Float.parseFloat(split(gameSave[i], " ")[1]), Float.parseFloat(split(gameSave[i], " ")[3])), Boolean.parseBoolean(split(gameSave[i], " ")[5]), Integer.parseInt(split(gameSave[i], " ")[7]), Integer.parseInt(split(gameSave[i], " ")[9]), new PVector(Float.parseFloat(split(gameSave[i], " ")[11]), Float.parseFloat(split(gameSave[i], " ")[13])), Integer.parseInt(split(gameSave[i], " ")[15]), Integer.parseInt(split(gameSave[i], " ")[17]), Integer.parseInt(split(gameSave[i], " ")[19]), Integer.parseInt(split(gameSave[i], " ")[21]), Boolean.parseBoolean(split(gameSave[i], " ")[23]));
            break;
          }
        }
        gameSave[gameSave.length - 1] = gameSave[gameSave.length - 1].replace(',', '.');
        _game = new Game(path.getAbsolutePath(), board, hero, _blinky, _inky, _pinky, _clyde, split(gameSave[gameSave.length - 1], " ")[1], Float.parseFloat(split(gameSave[gameSave.length - 1], " ")[3]));
        endPause();
      }
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
