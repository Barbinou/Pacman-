class Hero {
  // position on screen
  PVector _posOffset, _position;
  // position on board
  int _cellX, _cellY, _cacheMove, _move;
  // display size
  float _size;

  Board _board;

  PVector _direction;
  boolean _moving; // is moving ?

  Hero(Board b) {  // constructeur de hero
    _board = b;
    getCellHero();
    _direction = new PVector (0, 0);
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  void launchMove(PVector dir) {
  }

  void move(float target) {
    try {
      switch(_board._cells[_cellX + (int)_direction.x][_cellY + (int) _direction.y]) {
      case WALL :
        if (_move == RIGHT || _move == LEFT) {
          _position.x = target;
        } else {
          _position.y = target;
        }
        if (_cacheMove != 0) {
          deleteCacheMove();
        }
        break;
      }
      if (_board._cells[_cellX + (int)_direction.x][_cellY + (int)_direction.y] != TypeCell.WALL) {
        switch(_board._cells[_cellX][_cellY]) {
        case DOT:
          eatDOT();
          cacheMove();
          break;
        case SUPER_DOT:
        case PACMAN:
        case EMPTY:
          cacheMove();
          break;
        }
      }
    }
    catch(ArrayIndexOutOfBoundsException e) {  // si j'ai une erreur ArrayIndexOutOfBoundsException alors je remets mon pacman tout a droite
      eatDOT();
      if (e.toString().equals(ERROR)) {
        _position.x = width;
        _cellY = 22;
      } else {
        _position.x = 0;
        _cellY = 0;
      }
    }
  }

  void cacheMove() {
    switch (_cacheMove) {
    case UP:
      if (_board._cells[_cellX - 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    case RIGHT:
      if (_board._cells[_cellX][_cellY + 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    case DOWN:
      if (_board._cells[_cellX + 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    case LEFT:
      if (_board._cells[_cellX][_cellY - 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    default:
      updateCellsHero();
    }
  }

  void eatDOT() {
    for (TypeCell type : TypeCell.values()) {
      _board._cells[_cellX][_cellY] = type.EMPTY;
    }
  }

  void deleteCacheMove() {
    _move = _cacheMove;
    _cacheMove = 0;
  }

  void update() {
    drawIt();
  }

  void updateCellsHero() {
    _cellX += (int)_direction.x;
    _cellY += (int)_direction.y;
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
