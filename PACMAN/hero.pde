class Hero {
  // position on screen
  PVector _position;
  PVector _posOffset;
  // position on board
  int _cellX, _cellY; 
  // display size
  float _size;
  
  Board _board; 
  
  // move data
  PVector _direction;
  boolean _moving; // is moving ? 
    
  Hero() {
    _board = new Board(); 
  }
  
  void launchMove(PVector dir) {
  }
  
  void move(Board board) {
    getCellHero(board); 
    print("oui"); 
    // si j'appuie sur une touche sa bouge 
  }
  
  void update(Board board) {
  }
  
  void drawIt() {
    move(_board); 
  }
  
  void getCellHero(Board board){  // permet de retouver la posX et Y de pacman dans la grille 
    board.createBoard(); 
    for (int x = 0; x < board._cells.length; x++) {
      for (int y = 0; y <board._cells[x].length; y++) { 
        switch (board._cells[x][y]) {
          case PACMAN: 
            _cellX = x;
            _cellY = y; 
        }
      }
    }
  }
  
}
