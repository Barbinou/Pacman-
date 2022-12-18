public class Pinky extends Fantome {

  Pinky(Board b, Hero h) {
    super(b, h);
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

  @Override
    void drawIt() {
    if (!_frightened) {
      switch(_move) {
      case RIGHT:
        image(sprites.get(1), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      case DOWN:
        image(sprites.get(37), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      case LEFT:
        image(sprites.get(73), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      case UP:
        image(sprites.get(109), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      }
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
