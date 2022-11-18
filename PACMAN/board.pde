enum TypeCell {
  EMPTY ('V'), // EMPTY est un objet qui contient un char
    WALL ('x'),
    DOT ('o'),
    SUPER_DOT('O'),
    PACMAN ('P');

  final char CHARACTER;

  TypeCell(char character) {
    this.CHARACTER = character;  // recupère CHARACTER grâce a this.
  }

  char getChar() {
    return CHARACTER;
  }
}

class Board {
  TypeCell _cells[][];
  PVector _position;  // position du labyrinthe
  int _nbCellsX;
  int _nbCellsY;
  int _cellSize; // cells should be square

  Board(PVector position, int cellSize) {
    _position = position;
    _cellSize = cellSize;
  }

  void createBoard() {
    String[] lines = loadStrings("levels/level1.txt");
    _nbCellsX = lines.length; 
    
    for (int y = 1; y < lines.length; y++) {
      
      println(); 
      
      if (y == 1){
        _nbCellsY = lines[y].toCharArray().length;
        _cells = new TypeCell [_nbCellsX][_nbCellsY]; 
      }
      
      for (int x = 1; x < lines[y].toCharArray().length; x++) {  // toCharArray() permet de definir mon x (String) comme une liste de char
        for (TypeCell type : TypeCell.values()) {
          if (type.getChar() == lines[y].toCharArray()[x]){
            _cells [x][y] = type; 
            print(_cells [x][y]); 
          }
        }  
      }
    } 
  }

  PVector getCellCenter(int i, int j) {
    return null;
  }

  void drawIt() {
    createBoard();
  }
}
