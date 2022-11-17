enum TypeCell {
  EMPTY, WALL, DOT, SUPER_DOT // others ?
}

class Board {
  TypeCell _cells[][];
  PVector _position;  // position du labyrinthe 
  int _nbCellsX;
  int _nbCellsY;
  int _cellSize; // cells should be square
  
  Board(PVector position, int nbCellsX, int nbCellsY, int cellSize) {
    _position = position; 
    _nbCellsX = nbCellsX;
    _nbCellsY = nbCellsY;
    _cellSize = cellSize;
  }
  
  void create_board() {
    String[] lines = loadStrings("levels/level1.txt");
    for (int i = 0 ; i < lines.length; i++) {
      println(lines[i]);
}
  }
  
  PVector getCellCenter(int i, int j) {
    return null;
  }
  
  void drawIt() {
   create_board(); 
  }
}
