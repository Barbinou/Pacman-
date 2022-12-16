import java.util.*;
import processing.sound.*;

final int SCORE_DOT = 10;
final int SCORE_SUPER_DOT = 50;
final int SCORE_BONUS = 500;
final int ONE_UP = 10000;

final int LAST_LIFE = 1; 
final int HERO_LIFE = 2; 

Integer [] scoreGhostTab = {200, 400, 800, 1600};
List <Integer> SCORE_GHOST = new LinkedList <Integer> (Arrays.asList(scoreGhostTab));

final int SUPER_DOT_TIME_LIMIT = 10000; 
final int [] HIGHSCORE = {50, 100, 500, 1000, 5000};

static final color DARK_BLUE = #00008B; 
static final color WHITE = #FFFFFF; 
static final color YELLOW = #e5de00; 
static final color BLACK = 0; 
static final color GRAY = #808080; 
static final color RED = #FF0000;
static final color LIGHT_BLUE = #29b6f6; 
static final color PINK = #FF0080;
static final color ORANGE = #FF6600; 
static final color BROWN = #593E1A;
static final color BLUE = #0021F3; 
static final color GREEN = #00a000; 

final int ARRONDI = 20; 
final float CENTRAGE_POSY = 0.4;  // correspond au centre de la cellule -0.1 car on prend 90% de la hauteur de la fenetre 
final float CENTRAGE_POSX = 0.5;  // correspond au centre de la cellule 
int CENTRAGE_DE_MORT; 

float CELL_SIZE_X;
float GHOST_WIDTH; 
float GHOST_HEIGHT; 
float VITESSE_GHOST = 0.05; 
float SUPER_DOT; 
float DOT; 
final float VITESSE_HERO = 0.05; 

final String ERROR = "java.lang.ArrayIndexOutOfBoundsException: Index -1 out of bounds for length 23"; // erreur de OutOfBounds à gauche de l'écran 

Integer[] keys_tab = {122, 113, 115, 100}; // z, q, s, d traduit en int 
final List <Integer> KEYS = Arrays.asList(keys_tab); // converti ma tab en ArrayList 

Integer [] directions_tab = {LEFT, RIGHT, UP, DOWN};
List <Integer> DIRECTIONS = new LinkedList <Integer> (Arrays.asList(directions_tab)); 

final String [] MENU_PAUSE = {"Continuer", "Sauvegarder", "Charger", "Recommencer", "Highscores", "Quitter"};
final String [] END_VICTOIRE = {"Recommencer", "Highscores", "Quitter"};
String [] END_FLAWLESS = {"", "Recommencer", "Highscores", "Quitter"};
final String [] END_DEFAITE = {"Recommencer", "Highscores", "Quitter"};

final float MIN_MENU_Y = 0.6;  // positions des cases pour qu'elles soient centrées 
final float MAX_MENU_Y = 1.7;
