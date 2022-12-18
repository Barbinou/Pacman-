class Fruits {

  Board _board;
  Hero _hero;
  int _cellX, _cellY, _numberFruits;
  PVector _position;
  boolean _eatable;

  Fruits(Board b, Hero h) {
    _board = b;
    _hero = h;
    getCellFruits();
    _eatable = false;
    _numberFruits = 1;
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  Fruits(Board b, Hero h, boolean eatable, int numberFruits) {
    _board = b;
    _hero = h;
    getCellFruits();
    _eatable = eatable;
    _numberFruits = numberFruits;
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  void drawIt() {
    if (millis() - _game._timeNoPause >= 30000 && _numberFruits != 0) {
      _eatable = true;
      if (_eatable) {
        drawFruit();
      }
    }
  }

  void drawFruit() {
    image(sprites.get(12), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
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

  void getCellFruits() { // permet de retouver la posX et Y de pacman dans la grille
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
