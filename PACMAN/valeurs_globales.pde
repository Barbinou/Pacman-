import java.util.*;
import processing.sound.*;

// les differents enum pour les switchs

public enum GameState {
  FRIGHTENED,
    CHASE,
    END;
}

public enum Option {
  CONTINUER("CONTINUER"),
    SAUVEGARDER ("SAUVEGARDER"),
    CHARGER("CHARGER"),
    RECOMMENCER("RECOMMENCER"),
    HIGHSCORE("HIGHSCORE"),
    QUITTER("QUITTER");

  final String value;

  Option (final String value) {
    this.value = value;
  }

  final String getValue() {
    return value;
  }
}

public enum Object {
  HERO("HERO"),
    BLINKY("BLINKY"),
    INKY("INKY"),
    PINKY("PINKY"),
    CLYDE("CLYDE"),
    FRUIT("FRUIT"),
    GAME("GAME");

  final String value;

  Object (final String value) {
    this.value = value;
  }

  final String getValue() {
    return value;
  }
}

public enum TypeCell {
  EMPTY ('V', BLACK),
    WALL ('x', DARK_BLUE),
    DOT ('o', WHITE),
    SUPER_DOT('O', WHITE),
    PACMAN ('P', YELLOW),
    BLINKY ('B', RED),
    PINKY('R', PINK),
    INKY ('I', LIGHT_BLUE),
    CLYDE('C', ORANGE),
    DOOR('D', BROWN);

  final char CHARACTER;
  final color COL;

  TypeCell(char character, color col) {  // constructeur
    CHARACTER = character;
    COL = col;
  }

  char getChar() {  // fonction pour avoir les attributs de la classe
    return CHARACTER;
  }

  color getCol() {
    return COL;
  }
}

// variables pour le score

final int SCORE_START = 0;
final int SCORE_DOT = 10;
final int SCORE_SUPER_DOT = 50;
final int SCORE_BONUS = 500;
final int ONE_UP = 10000;
Integer [] scoreGhostTab = {200, 400, 800, 1600};
List <Integer> SCORE_GHOST = new LinkedList <Integer> (Arrays.asList(scoreGhostTab));

// gestion des vies

final int LAST_LIFE = 1;
final int HERO_LIFE = 2;
final int SUPER_DOT_TIME_LIMIT = 10000;

final String DEFAULT_NAME = "aaa";
String NAME_SPACE = "";
final char LETTER_A = 'a'; 
final char LETTER_Z = 'z'; 

// couleurs

static final color DARK_BLUE = #00008B;
static final color WHITE = #FFFFFF;
static final color YELLOW = #e5de00;
static final color BLACK = 0;
static final color RED = #FF0000;
static final color LIGHT_BLUE = #29b6f6;
static final color PINK = #FF0080;
static final color ORANGE = #FF6600;
static final color BROWN = #593E1A;
static final color BLUE = #0021F3;
static final color GREEN = #00a000;

// valeurs pour le responsive du jeu

float CELL_SIZE_X;
final float CENTRAGE_POSY = 0.4;  // correspond au centre de la cellule -0.1 car on prend 90% de la hauteur de la fenetre
final float CENTRAGE_POSX = 0.5;  // correspond au centre de la cellule
int CENTRAGE_DE_MORT;

// valeurs des fantomes pour le draw

float GHOST_WIDTH;
float GHOST_HEIGHT;
float VITESSE_GHOST = 0.05;

// ce qu'il reste en DOT ou SUPERDOT sur le board

float SUPER_DOT;
float DOT;

final float VITESSE_HERO = 0.05;

final String ERROR = "java.lang.ArrayIndexOutOfBoundsException: Index -1 out of bounds for length 23"; // erreur de OutOfBounds à gauche de l'écran

// liste pour le déplacment

Integer[] keys_tab = {122, 113, 115, 100}; // z, q, s, d traduit en int
final List <Integer> KEYS = Arrays.asList(keys_tab); // converti ma tab en ArrayList

Integer [] directions_tab = {LEFT, RIGHT, UP, DOWN};
List <Integer> DIRECTIONS = new LinkedList <Integer> (Arrays.asList(directions_tab));

// tous les menus possibles

static final String [] MENU_PAUSE = {Option.CONTINUER.getValue(), Option.SAUVEGARDER.getValue(), Option.CHARGER.getValue(), Option.RECOMMENCER.getValue(),
  Option.HIGHSCORE.getValue(), Option.QUITTER.getValue()};
final String [] END_VICTOIRE = {Option.SAUVEGARDER.getValue(), Option.HIGHSCORE.getValue(), Option.QUITTER.getValue()};
String [] END_FLAWLESS = {NAME_SPACE, Option.SAUVEGARDER.getValue(), Option.HIGHSCORE.getValue(), Option.QUITTER.getValue()};
final String [] END_DEFAITE = {Option.SAUVEGARDER.getValue(), Option.HIGHSCORE.getValue(), Option.QUITTER.getValue()};

// position des cases dans le menu

final int ARRONDI = 20;
final float MIN_MENU_Y = 0.6;
final float MAX_MENU_Y = 1.7;

// differents chemin pour les fichiers

final String BOARD_CREATE_FILE = "levels/level1.txt";
final String BOARD_SAVE_FILE = "boardSave.txt";
final String GAME_SAVE_FILE = "save.txt";
final String HIGHSCORE_FILE = "highscore.txt";
final String DATA_BOARD_SAVE_FILE = "/data/boardSave.txt";
final String DATA_GAME_SAVE_FILE = "/data/save.txt";

// valeurs dans les splits

final char COMMA = ',';
final char POINT = '.';
final String SEPARATOR = " ";
