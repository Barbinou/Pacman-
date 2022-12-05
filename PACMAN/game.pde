class Game
{
  Board _board;
  Hero _hero;

  String _levelName;

  Game() {
    _board = new Board();
    _hero = new Hero(_board);
  }

  void update() {
    float targetX = (width / _board._nbCellsX) * (_hero._cellY + CENTRAGE_POSX);
    float targetY = height * 0.9 / _board._nbCellsY * (_hero._cellX + CENTRAGE_POSY) + height * 0.1;
    if (_hero._move == LEFT) { 
      _hero._position.x -= CELL_SIZE_X * VITESSE_HERO;
      if (_hero._position.x <= targetX) {
        _hero.moveLeft();
      }
    }
    if (_hero._move == RIGHT) {
      _hero._position.x += CELL_SIZE_X * VITESSE_HERO;
      if (_hero._position.x >= targetX) {
        _hero.moveRight();
      }
    }
    if (_hero._move == UP) {
      _hero._position.y -= CELL_SIZE_X * VITESSE_HERO;
      if (_hero._position.y <= targetY) {
        _hero.moveUp();
      }
    }
    if (_hero._move == DOWN) {
      _hero._position.y += CELL_SIZE_X * VITESSE_HERO;
      if (_hero._position.y >= targetY) {
        _hero.moveDown();
      }
    }
    _hero.update();
  }

  void drawIt() {
    _board.drawIt();
  }

  void handleKey(int key) {
    float targetX = (width / _board._nbCellsX) * (_hero._cellY + CENTRAGE_POSX);
    float targetY = height * 0.9 / _board._nbCellsY * (_hero._cellX + CENTRAGE_POSY) + height * 0.1;
    if (key == CODED) {
      
      if (keyCode == LEFT) {
        if (_board._cells[_hero._cellX][_hero._cellY - 1].toString() != "WALL" && _hero._position.y == targetY) {
          _hero._move = LEFT;
        } else {
         _hero._cacheMove = LEFT;
        }
      }

      if (keyCode == RIGHT) {
        if (_board._cells[_hero._cellX][_hero._cellY + 1].toString() != "WALL" && _hero._position.y == targetY) {
          _hero._move = RIGHT;
        } else {
          _hero._cacheMove = RIGHT;
        }
      }

      if (keyCode == UP) {
        if (_board._cells[_hero._cellX - 1][_hero._cellY].toString() != "WALL" && _hero._position.x == targetX) { // cas de figure en mouvement regarder le croquis
          _hero._move = UP;
        } else {
          _hero._cacheMove = UP;
        }
      }

      if (keyCode == DOWN) {
        if ( _board._cells[_hero._cellX + 1][_hero._cellY].toString() != "WALL" && _hero._position.x == targetX) {
          _hero._move = DOWN;
        } else {
          _hero._cacheMove = DOWN;
        }
      }
    } else {
      if (key == 'q') {
        _hero.moveLeft();
      }
      if (key == 'd') {
        _hero.moveRight();
      }
      if (key == 'z') {
        _hero.moveUp();
      }
      if (key == 's') {
        _hero.moveDown();
      }
    }
  }
}
