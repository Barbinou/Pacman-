class Clyde {

  Board _board;
  int _cellX, _cellY, _move, _cacheMove;
  PVector _position, _direction;
  List <Integer> _directions = new ArrayList <>(DIRECTIONS);
  boolean _passage = false; // passage permet de savoir si les fantomes ont déjà traversé la porte pour ne pas les faire rerentrer dans la zone des fantomes 

  Clyde(Board b) {
    _board = b;
    _move = UP; // permet de faire sortir clyde de la zone des fantomes
    getCellClyde();
    _direction = new PVector (0, 0);
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1); 
  }

  // pour les commentaires de cette partie se référé aussi à la classe Hero et Blinky //

  void update() {
    float targetX = (width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX);
    float targetY = height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1;
    switch (_move) {
    case LEFT:
      _direction.set(0, -1);
      _position.x -= CELL_SIZE_X * VITESSE_HERO;
      if (_position.x <= targetX) {
        move(targetX);
      }
      break;
    case RIGHT:
      _direction.set(0, 1);
      _position.x += CELL_SIZE_X * VITESSE_HERO;
      if (_position.x >= targetX) {
        move(targetX);
      }
      break;
    case UP:
      _direction.set(-1, 0);
      _position.y -= CELL_SIZE_X * VITESSE_HERO;
      if (_position.y <= targetY) {
        move(targetY);
      }
      break;
    case DOWN:
      _direction.set(1, 0);
      _position.y += CELL_SIZE_X * VITESSE_HERO;
      if (_position.y >= targetY) {
        move(targetY);
      }
      break;
    }
    drawIt();
  }

  void drawIt() {
    noStroke();
    fill(ORANGE);
    ellipse(_position.x + _board._offset.x, _position.y, (width /_board._nbCellsY)*0.5, (height / _board._nbCellsX)*0.5);
  }

  void randomMove() {
    _directions = new ArrayList <>(DIRECTIONS);
    Collections.shuffle(_directions, new Random());
    switch (_move) {
    case LEFT:
      _directions.remove(Integer.valueOf(RIGHT));
      break;
    case RIGHT:
      _directions.remove(Integer.valueOf(LEFT));
      break;
    case UP:
      _directions.remove(Integer.valueOf(DOWN));
      break;
    case DOWN:
      _directions.remove(Integer.valueOf(UP));
      break;
    }
    _cacheMove = _directions.get(0);
    _directions.remove(0);
  }

  void updateCellsClyde() {
    _cellX += (int)_direction.x;
    _cellY += (int)_direction.y;
  }

  void move(float target) {
    try {
      switch(_board._cells[_cellX + (int)_direction.x][_cellY + (int) _direction.y]) {
      case WALL :
        wallGestion(target);
        break;
      case DOOR :
        if (!_passage) {  // gestion de la porte ouverture que dans un sens 
          _passage = true;
          cacheMove();
          break;
        }
        wallGestion(target);
        break;
      default:
        cacheMove();
      }
    }
    catch(ArrayIndexOutOfBoundsException e) {
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
    if (_directions.isEmpty()) {
      randomMove();
    }
    switch (_cacheMove) {
    case UP:
      if (_board._cells[_cellX - 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsClyde();
      }
      break;
    case RIGHT:
      if (_board._cells[_cellX][_cellY + 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsClyde();
      }
      break;
    case DOWN:
      if (_board._cells[_cellX + 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsClyde();
      }
      break;
    case LEFT:
      if (_board._cells[_cellX][_cellY - 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsClyde();
      }
      break;
    default:
      randomMove();
      updateCellsClyde();
    }
  }

  void deleteCacheMove() {
    _move = _cacheMove;
    _cacheMove = 0;
  }

  void wallGestion(float target) {
    if (_move == RIGHT || _move == LEFT) {
      _position.x = target;
      goodMove(); 
    } else {
      _position.y = target;
      goodMove(); 
    }
    if (_cacheMove != 0) {
      deleteCacheMove();
    }
  }

  void goodMove() {
    if (_cacheMove == 0) {
      _cacheMove = _directions.get(0);
      _directions.remove(0);
    }
  }

  void getCellClyde() {
    for (int x = 0; x < _board._cells.length; x++) {
      for (int y = 0; y < _board._cells[x].length; y++) {
        switch (_board._cells[x][y]) {
        case CLYDE:
          _cellX = x;
          _cellY = y;
        }
      }
    }
  }
}
