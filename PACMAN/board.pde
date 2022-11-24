enum TypeCell {
    EMPTY ('V', GRAY), // EMPTY est un objet qui contient un char et une couleur 
    WALL ('x', DARK_BLUE),
    DOT ('o', LIGHT_PINK),
    SUPER_DOT('O', LIGHT_PINK),
    PACMAN ('P', YELLOW);

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

public class Board {
  TypeCell _cells[][];
  PVector _position;  // position du labyrinthe
  int _nbCellsX, _nbCellsY, _cellSize;

  void createBoard() {  // fonction pour créer le board grace au fichier.txt du niveau 
    String[] lines = loadStrings("levels/level1.txt");
    _nbCellsX = lines.length - 1; // length pour ne pas prendre en compte le titre 

    for (int x = 1; x < lines.length; x++) { // x = 1 car la première ligne correspond à l'intitulé du niveau

      if (x == 1) {  // creation des variables 
        _nbCellsY = lines[x].toCharArray().length;
        _cells = new TypeCell [_nbCellsX][_nbCellsY];
        _position = new PVector((_nbCellsY / 10f)+ 0.56, 0.52);  //  valeur _position.x pour l'espace du score | valeur _position_y ne change que par rapport au width, les differentes valeurs sur carnet 
      }

      for (int y = 0; y < lines[x].toCharArray().length; y++) {  // toCharArray() permet de definir mon x (String) comme une liste de char
        for (TypeCell type : TypeCell.values()) {  // on parcourt notre type qui est un TypeCell 
          if (type.getChar() == lines[x].toCharArray()[y]) {
            _cells [x-1][y] = type;  // x-1 pour ne pas avoir des null a cause du titre 
          }
        }
      }
    }
  }

  void drawBoard() { // on dessine le board 
    for (int x = 0; x < _cells.length; x++) {
      for (int y = 0; y <_cells[x].length; y++) {  // parcours de _cells[][]

        noStroke();
        rectMode(CENTER);
        ellipseMode(CENTER);

        float posX = width/_nbCellsY*_position.y;
        float posY = height*0.9/_nbCellsX*_position.x;  // on veut garder 1/10 de la hauteur pour le score 

        for (TypeCell type : TypeCell.values()) {
          if (_cells[x][y] == type)
            fill(type.getCol());
        }

        switch (_cells[x][y]) {  // prends les differents cas de _cells[][] pour dessiner les differentes parties du board 
        case WALL:
        case EMPTY:
          rect(posX, posY, width /_nbCellsY, height / _nbCellsX);
          break;
        case DOT:
          ellipse(posX, posY, (width /_nbCellsX)*0.2, (height / _nbCellsY)*0.2);
          break;
        case SUPER_DOT:
          ellipse(posX, posY, (width /_nbCellsX)*0.5, (height / _nbCellsY)*0.5);
          break;
        case PACMAN:
          ellipse(posX, posY, (width /_nbCellsX)*0.7, (height / _nbCellsY)*0.7);
          break;
        default:
          fill(BLACK);
          rect(posX, posY, width /_nbCellsY, height / _nbCellsX);
          break;
        }
        
        if (y < (_cells[x].length - 1)) {
          _position.y++;  
        } else {
          _position.y -= y; // reinitialise y à sa position de départ 
        }
      }
      _position.x++;
    }
  }

  PVector getCellCenter(int i, int j) {
    return null;
  }

  void drawIt() {
    createBoard();
    drawBoard();
  }
}
