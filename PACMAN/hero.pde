class Hero {
  // position on screen
  PVector _posOffset, _position;
  // position on board
  int _cellX, _cellY;
  // display size
  float _size;

  Board _board;

  // move data
  PVector _direction;
  boolean _moving; // is moving ?

  Hero(Board b) {  // constructeur de hero
    _board = b;
    getCellHero();
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  void launchMove(PVector dir) {
  }

  void moveLeft() {
    try {
      switch(_board._cells[_cellX][_cellY - 1]) {
      case WALL :
        break;
      case DOT:
        for (TypeCell type : TypeCell.values()) {  // parcours des mon TypeCell
          _board._cells[_cellX][_cellY - 1] = type.EMPTY;
        }
        _cellY -= 1;
        break;
      case PACMAN:
      case SUPER_DOT:
      case EMPTY:
        _cellY -= 1;
        break;
      }
    }
    catch(ArrayIndexOutOfBoundsException error) {  // si j'ai une erreur AArrayIndexOutOfBoundsException alors je remets mon pacman tout a droite
      _cellY = 22;
    }
  }

  void moveRight() {
    try {
      switch(_board._cells[_cellX][_cellY + 1]) {
      case WALL :
        break;
      case DOT:
        for (TypeCell type : TypeCell.values()) {  // parcours des mon TypeCell
          _board._cells[_cellX][_cellY + 1] = type.EMPTY;
        }
        _cellY += 1;
        break;
      case PACMAN:
      case SUPER_DOT:
      case EMPTY:
        _cellY += 1;
        break;
      }
    }
    catch(ArrayIndexOutOfBoundsException e) { // pareil sauf qu'ici je me remets à gauche
      _cellY = 0;
    }
  }

  void moveUp() {
    switch(_board._cells[_cellX - 1][_cellY]) {
    case WALL :
      break;
    case DOT:
      for (TypeCell type : TypeCell.values()) {  // parcours des mon TypeCell
        _board._cells[_cellX - 1][_cellY] = type.EMPTY;
      }
      _cellX -= 1;
      break;
    case PACMAN:
    case SUPER_DOT:
    case EMPTY:
      _cellX -= 1;
      break;
    }
  }

  void moveDown() {
    switch(_board._cells[_cellX + 1][_cellY]) {
    case WALL :
      break;
    case DOT:
      for (TypeCell type : TypeCell.values()) {  // parcours des mon TypeCell
        _board._cells[_cellX + 1][_cellY] = type.EMPTY;
      }
      _cellX += 1;
      break;
    case PACMAN:
    case SUPER_DOT:
    case EMPTY:
      _cellX += 1;
      break;
    }
  }

  void update() {
    drawIt();
  }

  void drawIt() {
    noStroke();
    fill(YELLOW);
    ellipse(_position.x + _board._offset.x, _position.y, (width /_board._nbCellsY)*0.5, (height / _board._nbCellsX)*0.5);
  }

  void getCellHero() { // permet de retouver la posX et Y de pacman dans la grille
    for (int x = 0; x < _board._cells.length; x++) {
      for (int y = 0; y < _board._cells[x].length; y++) {
        switch (_board._cells[x][y]) {
        case PACMAN:
          _cellX = x;
          _cellY = y;
        }
      }
    }
  }
}
