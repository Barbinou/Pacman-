class Inky {

  Board _board;
  Hero _hero;
  int _cellX, _cellY, _move, _cacheMove;
  PVector _position, _direction;
  List <Integer> _directions = new ArrayList <>(DIRECTIONS);
  boolean _passage, _frightened;
  float _vitesse, _timeNoPause;
  color _color;

  Inky(Board b, Hero h, Game g) {
    _board = b;
    _hero = h; 
    _game = g;
    _passage = false;
    _vitesse = VITESSE_GHOST;
    _frightened = false;
    _color = LIGHT_BLUE;
    _move = RIGHT; // ici _move et _cacheMove sont les 2 premiers mouvement qui permettent à inky de sortir de la zone des fantomes
    _cacheMove = UP;
    getCellInky();
    _direction = new PVector (0, 0);
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  // pour les commentaires de cette partie se référé aussi à la classe Hero, Blinky et Clyde//

  void update() {
    frightenedMode();
    if (millis() - _game._timeNoPause >= 10000) { // si la partie à plus de 10s alors mon _inky bouge
      float targetX = (width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX);
      float targetY = height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1;
      switch (_move) {
      case LEFT:
        _direction.set(0, -1);
        _position.x -= CELL_SIZE_X * _vitesse;
        if (_position.x <= targetX) {
          move(targetX);
        }
        break;
      case RIGHT:
        _direction.set(0, 1);
        _position.x += CELL_SIZE_X * _vitesse;
        if (_position.x >= targetX) {
          move(targetX);
        }
        break;
      case UP:
        _direction.set(-1, 0);
        _position.y -= CELL_SIZE_X * _vitesse;
        if (_position.y <= targetY) {
          move(targetY);
        }
        break;
      case DOWN:
        _direction.set(1, 0);
        _position.y += CELL_SIZE_X * _vitesse;
        if (_position.y >= targetY) {
          move(targetY);
        }
        break;
      }
    }
  }

  void drawIt() {
    noStroke();
    fill(_color);
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

  void updateCellsInky() { // deplace PACMAN sur la grille
    _cellX += (int)_direction.x;
    _cellY += (int)_direction.y;
  }

  void move(float target) {
    try {
      switch(_board._cells[_cellX + (int)_direction.x][_cellY + (int) _direction.y]) {
      case WALL : // si la case est un mur
        wallGestion(target);
        break;
      case DOOR :
        if (!_passage) {
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
        updateCellsInky();
      }
      break;
    case RIGHT:
      if (_board._cells[_cellX][_cellY + 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsInky();
      }
      break;
    case DOWN:
      if (_board._cells[_cellX + 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsInky();
      }
      break;
    case LEFT:
      if (_board._cells[_cellX][_cellY - 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsInky();
      }
      break;
    default:
      randomMove();
      updateCellsInky();
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

  void frightenedMode() {
    if (_frightened) {
      _vitesse = 0.025;
      _color = BLUE;
    } else {
      _vitesse = VITESSE_GHOST;
      _color = LIGHT_BLUE;
    }
  }

  boolean conditionTouch() {
    boolean touchLeft = (_position.x <= _hero._position.x - (GHOST_WIDTH*0.5)) && (_hero._position.x - (GHOST_WIDTH*0.5) <= _position.x + (GHOST_WIDTH*0.5));
    boolean touchRight = (_position.x >= _hero._position.x + (GHOST_WIDTH*0.5) && _hero._position.x + (GHOST_WIDTH*0.5) >= _position.x - (GHOST_WIDTH*0.5));
    boolean samePosY = _position.y + 2 >= _hero._position.y &&  _position.y - 2 <= _hero._position.y;
    boolean touchUp = (_hero._position.y - (GHOST_HEIGHT*0.5) >= _position.y) && (_hero._position.y - (GHOST_HEIGHT*0.5) <= _position.y + (GHOST_HEIGHT*0.5));
    boolean touchDown = (_hero._position.y + (GHOST_HEIGHT*0.5) <= _position.y) && (_hero._position.y + (GHOST_HEIGHT) >= _position.y - (GHOST_HEIGHT*0.5));
    boolean samePosX = _position.x + 2 >= _hero._position.x &&  _position.x - 2 <= _hero._position.x;
    return ((samePosY && (touchLeft || touchRight)) || (samePosX && (touchDown || touchUp)));
  }

  void getCellInky() {
    for (int x = 0; x < _board._cells.length; x++) {
      for (int y = 0; y < _board._cells[x].length; y++) {
        switch (_board._cells[x][y]) {
        case INKY:
          _cellX = x;
          _cellY = y;
        }
      }
    }
  }
}
