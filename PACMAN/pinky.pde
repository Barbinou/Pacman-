public class Pinky extends Fantome {

  Pinky(Board b, Hero h) {
    super(b, h);
    _passage = false;
    _move = LEFT;
    _cacheMove = UP;
    getCellPinky();
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  Pinky(Board b, Hero h, PVector position, Boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX, int cellY, boolean passage) {
    super(b, h);
    _position = position;
    _cellY = cellY;
    _cellX = cellX;
    _passage = passage;
    _move = move;
    _cacheMove = cacheMove;
    _frightened = frightened;
    _direction = direction;
    _directions.add(directions1);
    _directions.add(directions2);
  }

  @Override
    void update() {
    frightenedMode();
    if (millis() - _game._timeNoPause >= 15000 || _passage) {
      super.update();
    }
  }

  void frightenedMode() {
    if (_frightened) {
      _vitesse = 0.025;
      _color = BLUE;
    } else {
      _vitesse = VITESSE_GHOST;
      _color = PINK;
    }
  }

  void getCellPinky() {
    for (int x = 0; x < _board._cells.length; x++) {
      for (int y = 0; y < _board._cells[x].length; y++) {
        switch (_board._cells[x][y]) {
        case PINKY:
          _cellX = x;
          _cellY = y;
        }
      }
    }
  }
}
