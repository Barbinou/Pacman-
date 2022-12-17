import java.io.BufferedWriter;
import java.io.FileWriter;
class Menu {

  Blinky _blinky;
  Clyde _clyde;
  Inky _inky;
  Pinky _pinky;
  Fruits _fruit;

  float _backgroundPosX, _backgroundPosY, _time;
  boolean _highscoreMenu, _possibilitySaveName;
  String [] _highscore;
  String _pseudo;

  Menu(Game g, Board b) {
    _game = g;
    _board = b;
    _pseudo = DEFAULT_NAME;
    _highscore = loadStrings(HIGHSCORE_FILE);
    // position du background au millieu de l'écran
    _backgroundPosX = width*0.5;
    _backgroundPosY = height*0.5;
    _highscoreMenu = false;
    _possibilitySaveName = true;
    _time = millis(); // enregistre le temps passé avant l'apparition du menu
  }

  Menu(Game g, Board b, float t) { // overload du constructeur pour la gestion de la second pause et plus
    _game = g;
    _board = b;
    _pseudo = DEFAULT_NAME;
    _backgroundPosX = width*0.5;
    _backgroundPosY = height*0.5;
    _highscoreMenu = false;
    _time = t;
  }

  void drawIt() {
    drawBackground();
    // Si le jeu n'est pas terminé
    if (_game._gameState != GameState.END) {
      // Si le menu des highscores n'est pas affiché
      if (!_highscoreMenu) {
        // Affiche le menu de pause
        drawCases(MENU_PAUSE);
      } else {
        drawCases(_highscore);
      }
    } else {
      // Si le menu des highscores est affiché
      if (_highscoreMenu) {
        endTitle("HIGHSCORES");
        // Affiche le menu des highscores
        drawCases(_highscore);
      } else if (_game._hero._score >= Integer.parseInt(split(_highscore[_highscore.length - 1], " ")[1]) && _possibilitySaveName) {
        // Si le score est supérieur ou égal au dernier highscore et si _possibilitySaveName est vrai
        // Affiche l'écran de victoire et defaite tout en pouvant enregistrer mon score
        drawCases(END_FLAWLESS);
        // Affiche l'écran de victoire
        if (DOT == 0) {
          endTitle("FLAWLESS VICTORY");
        } else { // Affiche l'écran de défaite
          endTitle("DEFEAT");
        }
        // Affiche le nom et le score
        fill(WHITE);
        text(String.format("%s %s : %d", Option.NAME, _pseudo.toUpperCase(), _game._hero._score), _backgroundPosX, _backgroundPosY*MIN_MENU_Y);
      } else {
        // Si j'ai deja enregistrer mon score ou que mon score n'est pas plus grand que le plus petit highscore
        if (DOT == 0) {
          drawCases(END_VICTOIRE);
          endTitle("VICTORY");
        } else {
          drawCases(END_DEFAITE);
          endTitle("GAME OVER");
        }
      }
    }
  }

  void endTitle(String title) { // titre de fin
    textAlign(CENTER, CENTER);
    textSize(CELL_SIZE_X*0.8);
    fill(YELLOW);
    // Le texte est positionné au milieu de l'écran à un dixieme de la hauteur
    text(title, width/2, height*0.1);
  }

  void drawBackground() { // background lors de la pause
    rectMode(CORNER);
    fill(BLACK);
    // Sa hauteur est de la hauteur de l'écran, sauf si l'état du jeu est "END", auquel cas elle est de 0
    rect(0, _game._gameState != GameState.END ? height * 0.09 : 0, width, height);
    fill(YELLOW);
    // hauteur et sa largeur sont respectivement de 70% et 60% de celles de l'écran
    rect(width * 0.2, height * 0.2, width * 0.6, height * 0.7, ARRONDI);
  }

  void drawCases(String[] writeMenu) { // dessine les cases
    rectMode(CENTER);
    int j = 0;
    // boucle qui me permet d'avoir toujours les éléments de writeMenu dans le carré jaune
    for (float i = MIN_MENU_Y; i < MAX_MENU_Y; i += (float) 1 / (writeMenu.length - 1)) {
      hitboxCase(i, j, writeMenu);
      // dessine les rectangles contenant le texte de writeMenu
      // positionY et une hauteur respectivement en fonction de i et de la longueur du tableau writeMenu
      rect(_backgroundPosX, _backgroundPosY*i, _backgroundPosX, _backgroundPosY / (writeMenu.length + 1), ARRONDI);
      textAlign(CENTER, CENTER);
      fill(WHITE);
      text(writeMenu[j], _backgroundPosX, _backgroundPosY*i);
      j++;
    }
  }

  void optionMenu(int j, String[] writeMenu) {

    String argument = writeMenu[j];

    if (writeMenu[j].equals(Option.NAME.getValue())) {
      if (mouseButton == LEFT && mousePressed) {
        mousePressed = false;
        if (_pseudo.length() == 3) {
          // Parcourir le tableau _highscore de la fin vers le début
          for (int i = _highscore.length - 1; i >= 0; i--) {
            // Si la valeur du score dans le tableau _highscore est inférieure au score du héros et que je n'ai pas encore sauvegardé mon nom
            if (Integer.parseInt(split(_highscore[i], SEPARATOR)[1]) <= _game._hero._score && _possibilitySaveName) {
              // Mettre à jour la valeur de _highscore
              _highscore[i] = String.format("%s %d", _pseudo.toUpperCase(), _game._hero._score);
              _possibilitySaveName = false;
            }
          }
          // Trier la liste en utilisant une expression lambda
          Arrays.sort(_highscore, (s1, s2) -> {
            // Récupérer le nombre dans chaque chaîne de caractères
            int v1 = Integer.parseInt(split(s1, SEPARATOR)[1]);
            int v2 = Integer.parseInt(split(s2, SEPARATOR)[1]);
            // Comparer les valeurs v1 et v2 et renvoyer le résultat
            return Integer.compare(v2, v1);
          }
          );

          // Écrire chaque élément du tableau _highscore dans le fichier highscore.txt
          try (BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + "/data/highscore.txt"))) {
            for (int i = 0; i < _highscore.length; i++) {
              if (i == 0) {
                // ecrire avec sans retour à la ligne
                writer.write(_highscore[i]);
              } else {
                // ecrire avec un retour à la ligne
                writer.write("\n" + _highscore[i]);
              }
            }
          }
          catch (IOException e) {
            e.printStackTrace();
          }
          _highscoreMenu = false;
        }
      }
    }
    try {
      switch(Option.valueOf(argument)) {
      case CONTINUER:
        if (mouseButton == LEFT && mousePressed) {
          // Mettre à jour la valeur de mousePressed
          mousePressed = false;
          // retour au jeu
          endPause();
        }
        break;
      case SAUVEGARDER:
        if (mouseButton == LEFT && mousePressed) {
          mousePressed = false;
          // creation d'un objet qui permet d'écrire dans un fichier
          try (BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + DATA_BOARD_SAVE_FILE))) {
            // enregiste l'état du plateau
            _board.saveBoard(writer);
          }
          catch (IOException e) {
            e.printStackTrace();
          }
          try (BufferedWriter writer = new BufferedWriter(new FileWriter(_game._path + DATA_GAME_SAVE_FILE))) {
            // enregiste l'état de la partie
            _game.saveGame(writer);
          }
          catch (IOException e) {
            e.printStackTrace();
          }
          endPause();
        }
        break;
      case CHARGER:
        if (mouseButton == LEFT && mousePressed) {
          mousePressed = false;
          // charge les deux fichiers de sauvegardes
          String boardSave [] = loadStrings(BOARD_SAVE_FILE);
          String gameSave [] = loadStrings(GAME_SAVE_FILE);

          Board board;
          Hero hero;
          Blinky blinky;
          Inky inky;
          Pinky pinky;
          Clyde clyde;
          Fruits fruit;

          board = new Board(boardSave);
          hero = new Hero(board);

          for (int i = 1; i < gameSave.length; i++) {
            // String.format() les float sont sauvegarde avec des virgules
            // replace permet de corriger ce souci
            gameSave[i] = gameSave[i].replace(COMMA, POINT);
            String object = split(gameSave[i], SEPARATOR)[0];
            switch (Object.valueOf(object)) {
            case HERO:
              /* load de Hero(Board b, PVector position, PVector direction, boolean overpowered, int life, int score, int cacheLifeUp, int move, int cacheMove,
               int cellX, int cellY)*/
              hero = new Hero(board, new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[1]), Float.parseFloat(split(gameSave[i], SEPARATOR)[3])),
                new PVector (Float.parseFloat(split(gameSave[i], SEPARATOR)[5]), Float.parseFloat(split(gameSave[i], SEPARATOR)[7])),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[9]), Integer.parseInt(split(gameSave[i], SEPARATOR)[11]), Integer.parseInt(split(gameSave[i], SEPARATOR)[13]),
                Integer.parseInt(split(gameSave[i], SEPARATOR)[15]), Integer.parseInt(split(gameSave[i], SEPARATOR)[17]), Integer.parseInt(split(gameSave[i], SEPARATOR)[19]),
                Integer.parseInt(split(gameSave[i], SEPARATOR)[21]), Integer.parseInt(split(gameSave[i], SEPARATOR)[23]));
              break;
            case BLINKY:
              /* load de Blinky(Board b, Hero h, PVector position, boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2,
               int cellX, int cellY)*/
              _blinky = new Blinky(board, hero, new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[1]), Float.parseFloat(split(gameSave[i], SEPARATOR)[3])),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[5]), Integer.parseInt(split(gameSave[i], SEPARATOR)[7]), Integer.parseInt(split(gameSave[i], SEPARATOR)[9]),
                new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[11]), Float.parseFloat(split(gameSave[i], SEPARATOR)[13])), Integer.parseInt(split(gameSave[i], SEPARATOR)[15]),
                Integer.parseInt(split(gameSave[i], SEPARATOR)[17]), Integer.parseInt(split(gameSave[i], SEPARATOR)[19]), Integer.parseInt(split(gameSave[i], SEPARATOR)[21]));
              break;
            case INKY:
              /* load de Inky (Board b, Hero h, PVector position, boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX,
               int cellY, boolean passage)*/
              _inky = new Inky(board, hero, new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[1]), Float.parseFloat(split(gameSave[i], SEPARATOR)[3])),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[5]), Integer.parseInt(split(gameSave[i], SEPARATOR)[7]), Integer.parseInt(split(gameSave[i], SEPARATOR)[9]),
                new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[11]), Float.parseFloat(split(gameSave[i], SEPARATOR)[13])), Integer.parseInt(split(gameSave[i], SEPARATOR)[15]),
                Integer.parseInt(split(gameSave[i], SEPARATOR)[17]), Integer.parseInt(split(gameSave[i], SEPARATOR)[19]), Integer.parseInt(split(gameSave[i], SEPARATOR)[21]),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[23]));
              break;
            case PINKY:
              /* load de Pinky (Board b, Hero h, PVector position, boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX,
               int cellY, boolean passage)*/
              _pinky = new Pinky(board, hero, new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[1]), Float.parseFloat(split(gameSave[i], SEPARATOR)[3])),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[5]), Integer.parseInt(split(gameSave[i], SEPARATOR)[7]), Integer.parseInt(split(gameSave[i], SEPARATOR)[9]),
                new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[11]), Float.parseFloat(split(gameSave[i], SEPARATOR)[13])), Integer.parseInt(split(gameSave[i], SEPARATOR)[15]),
                Integer.parseInt(split(gameSave[i], SEPARATOR)[17]), Integer.parseInt(split(gameSave[i], SEPARATOR)[19]), Integer.parseInt(split(gameSave[i], SEPARATOR)[21]),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[23]));
              break;
            case CLYDE:
              /* load de Clyde (Board b, Hero h, PVector position, boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX,
               int cellY, boolean passage)*/
              _clyde = new Clyde(board, hero, new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[1]), Float.parseFloat(split(gameSave[i], SEPARATOR)[3])),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[5]), Integer.parseInt(split(gameSave[i], SEPARATOR)[7]), Integer.parseInt(split(gameSave[i], SEPARATOR)[9]),
                new PVector(Float.parseFloat(split(gameSave[i], SEPARATOR)[11]), Float.parseFloat(split(gameSave[i], SEPARATOR)[13])), Integer.parseInt(split(gameSave[i], SEPARATOR)[15]),
                Integer.parseInt(split(gameSave[i], SEPARATOR)[17]), Integer.parseInt(split(gameSave[i], SEPARATOR)[19]), Integer.parseInt(split(gameSave[i], SEPARATOR)[21]),
                Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[23]));
              break;
            case FRUIT:
              // load de Fruits (Board b, Hero h, boolean eatable, int numberFruits)
              _fruit = new Fruits(board, hero, Boolean.parseBoolean(split(gameSave[i], SEPARATOR)[1]), Integer.parseInt(split(gameSave[i], SEPARATOR)[3]));
              break;
            case GAME:
              float gameTime = Float.parseFloat(split(gameSave[gameSave.length - 1], SEPARATOR)[3]);
              if (millis() - gameTime <= 0) {
                gameTime = millis(); // evite un nombre negatif dans la condition de sortie 
              } else {
                gameTime = millis() - gameTime; 
              }
              _game = new Game(path.getAbsolutePath(), board, hero, _blinky, _inky, _pinky, _clyde, _fruit, GameState.valueOf(split(gameSave[gameSave.length - 1], SEPARATOR)[1]),
                gameTime);
              break;
            }
          }
        }
        break;
      case RECOMMENCER:
        if (mouseButton == LEFT && mousePressed) {
          mousePressed = false;  // permet de ne plus enregistrer la touche comme appuyé
          _game = new Game(path.getAbsolutePath());
          _game._menu._time = millis();  // garde en mémoire le reset
          _game._timeNoPause = millis();  // permet de remettre les conditions de sortie au débuts
          _game._gameRetry = true;
        }
        break;
      case HIGHSCORE:
        if (mouseButton == LEFT && mousePressed) {
          _highscoreMenu = true;
          mousePressed = false;
        }
        break;
      case QUITTER:
        if (mouseButton == LEFT && mousePressed) {
          exit();
        }
        break;
      }
    }
    catch (IllegalArgumentException e) {
      // gère le fait que les highscores ne sont pas présents dans l'enum Option
    }
  }

  void endPause() { // fonction qui fini la pause et qui recheck le temps
    _highscoreMenu = false;
    _game._gamePaused = false;
    _game._timeNoPause = (millis() - _time); // correpsond au temps écoule depuis le lancement du programme - le temps depuis le depuis de la pause
    _game._menu._time = millis() - _game._timeNoPause; // correpsond au temps en sortie du menu
  }

  void hitboxCase(float i, int j, String [] writeMenu) { // fonction qui gere les fonctionalités de mon menu
    // i est une coordonnée en Y qui correspond à une case du menu.
    // j est un indice qui permet de récupérer la chaîne de caractères correspondant à la case du menu.

    // Si la souris se trouve sur la case du menu (selon ses coordonnées en X et en Y).
    if (mouseY >= (_backgroundPosY*i) - _backgroundPosY / 12 && mouseY <= (_backgroundPosY*i)+ _backgroundPosY / 12 && mouseX <= _backgroundPosX + _backgroundPosX *0.5 && mouseX >= _backgroundPosX - _backgroundPosX *0.5 ) { // si je suis sur la case
      fill(RED);
      //differentes possibliltés du menu
      optionMenu(j, writeMenu);
    } else {
      fill(BLUE);
      if (mouseButton == LEFT && mousePressed && _highscoreMenu) { // Revenir au jeu lorsque je clique n'importe où dans le highscore
        mousePressed = false;
        endPause();
      }
    }
  }
}
