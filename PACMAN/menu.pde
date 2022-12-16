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
  Fruits _fruit;

  float _backgroundPosX, _backgroundPosY, _time;
  boolean _highscoreMenu, _oneValue;
  String [] _highscore;
  String _pseudo;

  Menu(Game g, Board b) {
    _game = g;
    _board = b;
    _pseudo = "aaa";
    _highscore = loadStrings("highscore.txt");
    _backgroundPosX = width*0.5;
    _backgroundPosY = height*0.5;
    _highscoreMenu = false;
    _oneValue = true;
    _time = millis(); // enregistre le temps passé avant l'apparition du menu
  }

  Menu(Game g, Board b, float t) { // overload du constructeur pour la gestion de la second pause et plus
    _game = g;
    _board = b;
    _pseudo = "aaa";
    _backgroundPosX = width*0.5;
    _backgroundPosY = height*0.5;
    _highscoreMenu = false;
    _time = t;
  }

  void drawIt() {
    if (!_game._gameState.equals("END") && !_highscoreMenu) {
      drawBackground();
      drawCases(MENU_PAUSE);
    } else if (_highscoreMenu) {
      drawBackground();
      drawCases(_highscore);
    } else if (DOT == 0) {
      drawBackground();
      if (_game._hero._score >= Integer.parseInt(split(_highscore[_highscore.length - 1], " ")[1]) && _oneValue) {
        drawCases(END_FLAWLESS);
        endTitle("FLAWLESS VICTORY");
        fill(WHITE);
        text(String.format("Name %s : %d", _pseudo.toUpperCase(), _game._hero._score), _backgroundPosX, _backgroundPosY*MIN_MENU_Y);
      } else {
        drawCases(END_VICTOIRE);
        endTitle("VICTORY");
      }
    } else {
      drawBackground();
      if (_game._hero._score >= Integer.parseInt(split(_highscore[_highscore.length - 1], " ")[1]) && _oneValue) {
        drawCases(END_FLAWLESS);
        endTitle("FLAWLESS VICTORY");
        fill(WHITE);
        text(String.format("Name %s : %d", _pseudo.toUpperCase(), _game._hero._score), _backgroundPosX, _backgroundPosY*MIN_MENU_Y);
      } else if (_game._hero._score >= Integer.parseInt(split(_highscore[_highscore.length - 1], " ")[1]) && _oneValue) {
        drawCases(END_VICTOIRE);
        endTitle("ANOTHER TRY");
      } else {
        drawCases(END_DEFAITE);
        endTitle("GAME OVER");
      }
    }
  }

  void endTitle(String title) {
    textAlign(CENTER, CENTER);
    textSize(CELL_SIZE_X*0.8);
    fill(YELLOW);
    text(title, width/2, height*0.1);
  }

  void drawBackground() { // dessine le background noir et jaune
    if (!_game._gameState.equals("END")) {
      rectMode(CORNER);
      fill(BLACK);
      rect(0, height*0.09, width, height);
      rectMode(CORNER);
      fill(YELLOW);
      rect(width * 0.2, height*0.2, width*0.6, height*0.7, ARRONDI);
    } else {
      rectMode(CORNER);
      fill(BLACK);
      rect(0, 0, width, height);
      fill(YELLOW);
      rect(width * 0.2, height*0.2, width*0.6, height*0.7, ARRONDI);
    }
  }

  void drawCases(String[] writeMenu) { // dessine les cases
    rectMode(CENTER);
    int j = 0;
    for (float i = MIN_MENU_Y; i < MAX_MENU_Y; i += (float) 1 / (writeMenu.length - 1)) {
      hitboxCase(i, j, writeMenu);
      rect(_backgroundPosX, _backgroundPosY*i, _backgroundPosX, _backgroundPosY / (writeMenu.length + 1), ARRONDI);
      textAlign(CENTER, CENTER);
      fill(WHITE);
      text(writeMenu[j], _backgroundPosX, _backgroundPosY*i);
      j++;
    }
  }

  void optionMenu(int j, String[] writeMenu) {
    switch(writeMenu[j]) {
    case "Continuer":
      if (mouseButton == LEFT && mousePressed) {
        mousePressed = false; 
        endPause();
      }
      break;
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
          writer.close();
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
        Fruits fruit; 

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
          case "_fruit._eatable":
            _fruit = new Fruits(board, hero, Boolean.parseBoolean(split(gameSave[i], " ")[1]), Integer.parseInt(split(gameSave[i], " ")[3]));
            break; 
          }
        }
        gameSave[gameSave.length - 1] = gameSave[gameSave.length - 1].replace(',', '.');
        _game = new Game(path.getAbsolutePath(), board, hero, _blinky, _inky, _pinky, _clyde, _fruit, split(gameSave[gameSave.length - 1], " ")[1], Float.parseFloat(split(gameSave[gameSave.length - 1], " ")[3]));
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
      if (mouseButton == LEFT && mousePressed) {
        _highscoreMenu = true;
        mousePressed = false;
      }
      break;
    case "Quitter":
      if (mouseButton == LEFT && mousePressed) {
        exit();
      }
      break;
    default:
      if (mouseButton == LEFT && mousePressed) {
        mousePressed = false;
        if (_pseudo.length() == 3) {
          for (int i = _highscore.length - 1; i >= 0; i--) {
            if (Integer.parseInt(split(_highscore[i], " ")[1]) <= _game._hero._score && _oneValue) {
              _highscore[i] = String.format("%s %d", _pseudo.toUpperCase(), _game._hero._score);
              _oneValue = false;
            }
          }
          // Trier la liste en utilisant une expression lambda
          Arrays.sort(_highscore, (s1, s2) -> {
            // Récupérer le nombre dans chaque chaîne de caractères
            int v1 = Integer.parseInt(split(s1, " ")[1]);
            int v2 = Integer.parseInt(split(s2, " ")[1]);
            return Integer.compare(v2, v1);
          }
          );
          try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + "/data/highscore.txt")); // creattion du fichier save.txt
            for (int i = 0; i < _highscore.length; i++) {
              if (i == 0) {
                writer.write(_highscore[i]);
              } else {
                writer.write("\n" + _highscore[i]);
              }
            }
            writer.close(); // fermeture du fichier
          }
          catch (IOException e) {
            e.printStackTrace();
          }
          _highscoreMenu = false;
          break;
        }
      }
    }
  }

  void endPause() { // fonction qui fini la pause
    _highscoreMenu = false;
    _game._gamePaused = false;
    _game._timeNoPause = (millis() - _time); // correpsond au temps écoule depuis le lancement du programme - le temps depuis le depuis de la pause
    _game._menu._time = millis() - _game._timeNoPause; // correpsond au temps en sortie du menu
  }

  void hitboxCase(float i, int j, String [] writeMenu) { // fonction qui gere les fonctionalités de mon menu
    if (mouseY >= (_backgroundPosY*i) - _backgroundPosY / 12 && mouseY <= (_backgroundPosY*i)+ _backgroundPosY / 12 && mouseX <= _backgroundPosX + _backgroundPosX *0.5 && mouseX >= _backgroundPosX - _backgroundPosX *0.5 ) { // si je suis sur la case
      fill(RED);
      optionMenu(j, writeMenu);
    } else {
      fill(BLUE);
      if (mouseButton == LEFT && mousePressed && _highscoreMenu) { // reviens au jeu lorsque je clique n'importe ou dans le menu highscore 
        mousePressed = false;
        endPause();
      }
    }
  }
}
