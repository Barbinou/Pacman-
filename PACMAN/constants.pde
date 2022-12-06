import java.util.*;

final int SCORE_DOT = 10;
final int SCORE_SUPER_DOT = 50;

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

final float CENTRAGE_POSY = 0.4;  // correspond au centre de la cellule -0.1 car on prend 90% de la hauteur de la fenetre 
final float CENTRAGE_POSX = 0.5;  // correspond au centre de la cellule 
int CENTRAGE_DE_MORT; 

float CELL_SIZE_X;
final float VITESSE_HERO = 0.05; 
final int TARGET_HITBOX = 5; // la taille de la target est de 5x5 pixels 

final String ERROR = "java.lang.ArrayIndexOutOfBoundsException: Index -1 out of bounds for length 23"; // erreur de OutOfBounds à gauche de l'écran 

Integer[] keys_tab = {122, 113, 115, 100}; // z, q, s, d traduit en int 
final List <Integer> KEYS = Arrays.asList(keys_tab); // converti ma tab en ArrayList 

Integer [] directions_tab = {LEFT, RIGHT, UP, DOWN};
List <Integer> DIRECTIONS = new LinkedList <Integer> (Arrays.asList(directions_tab)); 
