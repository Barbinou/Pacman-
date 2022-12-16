public enum TypeCell {
  EMPTY ('V', BLACK), // EMPTY est un objet qui contient un char et une couleur
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

class Board {
  TypeCell _cells[][];
  PVector _position, _offset;  // position du labyrinthe
  int _nbCellsY, _nbCellsX;

  Board (String[] data) {
    createBoard(data);
  }

  void createBoard(String [] lines) {  // fonction pour créer le board grace au fichier.txt du niveau
    _nbCellsY = lines.length - 1; // length pour ne pas prendre en compte le titre

    for (int x = 1; x < lines.length; x++) { // x = 1 car la première ligne correspond à l'intitulé du niveau

      if (x == 1) {  // creation des variables
        _nbCellsX = lines[x].toCharArray().length;
        _cells = new TypeCell [_nbCellsY][_nbCellsX];
        GHOST_WIDTH = (width /_nbCellsY)*0.5;
        GHOST_HEIGHT = (height /_nbCellsX)*0.5;
        centrage_de_mort();
        _offset = new PVector(CENTRAGE_DE_MORT, 0);
        _position = new PVector((_nbCellsX / 10f)+ 0.56, 0.5);  // valeur _position.x pour l'espace du score en haut | valeur _position.Y à cause du CENTER mode
      }

      for (int y = 0; y < lines[x].toCharArray().length; y++) {  // toCharArray() permet de definir mon x (String) comme une liste de char
        for (TypeCell type : TypeCell.values()) {  // on parcourt notre type qui est un TypeCell
          if (type.getChar() == lines[x].toCharArray()[y]) {
            _cells [x-1][y] = type;  // x-1 pour ne pas avoir des null a cause du titre
            switch (type) {
            case SUPER_DOT:
              SUPER_DOT += 1;
              break;
            case DOT:
              DOT += 1; 
              break; 
            }
          }
        }
      }
    }
  }

  void saveBoard(BufferedWriter writer) {
    try { // try and catch obligatoire lors de l'ecriture
      for (int x = 0; x < _board._cells.length; x++) { // je parcours mon board
        writer.write("\n");
        for (int y = 0; y <_board._cells[x].length; y++) {
          for (TypeCell type : TypeCell.values()) { // je parcours tous mes types de TypeCell
            if (_board._cells[x][y] == type)
              writer.write(type.getChar()); // j'ecris dans le fichier le char correpsondant au type de la cellule
          }
        }
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  void drawBoard() { // on dessine le board
    for (int x = 0; x < _cells.length; x++) {
      for (int y = 0; y <_cells[x].length; y++) {  // parcours de _cells[][]

        noStroke();
        rectMode(CENTER);
        ellipseMode(CENTER);

        float posX = width/_nbCellsX*_position.y;
        float posY = height*0.9/_nbCellsY*_position.x;  // on veut garder 1/10 de la hauteur pour le score

        for (TypeCell type : TypeCell.values()) {  // parcours des mon TypeCell
          if (_cells[x][y] == type)
            fill(type.getCol()); // aplliquer la couleur correspondante
        }

        CELL_SIZE_X = width /_nbCellsX;

        switch (_cells[x][y]) {  // prends les differents cas de _cells[][] pour dessiner les differentes parties du board
        case WALL:
        case DOOR:
        case EMPTY:
          rect(posX + _offset.x, posY, width /_nbCellsX, height*0.9 / _nbCellsY);  // offset.x correspond à CENTRAGE_DE_MORT pour centrer le board et 9/10 de la hauteur pour le rect à cause du placement du score
          break;
        case DOT:
          ellipse(posX + _offset.x, posY, (width /_nbCellsY)*0.2, (height / _nbCellsX)*0.2);
          break;
        case SUPER_DOT:
          ellipse(posX + _offset.x, posY, (width /_nbCellsY)*0.5, (height / _nbCellsX)*0.5);
          break;
        default:
          fill(BLACK);
          rect(posX + _offset.x, posY, width /_nbCellsX, height*0.9 / _nbCellsY);
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
    _position.x -= _nbCellsY;
  }

  void centrage_de_mort() {
    CENTRAGE_DE_MORT =  (width % ((int) width / _nbCellsX)) / 2;  // calcul le nombre de pixels à droite de l'ecran et le divise par 2 pour centrer le board
  }

  void printBoard() {
    for (int x = 0; x < _cells.length; x++) {
      println();
      for (int y = 0; y <_cells[x].length; y++) {
        print(_board._cells[x][y] + " ");
      }
    }
  }

  void drawIt() {
    drawBoard();
  }
}
