public class Clyde extends Fantome{

  Clyde(Board b, Hero h) {
    super(b, h); 
    _passage = false; // passage permet de savoir si les fantomes ont déjà traversé la porte pour ne pas les faire rerentrer dans la zone des fantomes
    _move = UP; // permet de faire sortir clyde de la zone des fantomes
    getCellClyde();
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1);
  }

  Clyde(Board b, Hero h, PVector position, Boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX, int cellY, boolean passage) {
    super(b, h); 
    _position = position;
    _cellY = cellY; 
    _cellX = cellX;
    _passage = passage; // passage permet de savoir si les fantomes ont déjà traversé la porte pour ne pas les faire rerentrer dans la zone des fantomes
    _frightened = frightened;
    _vitesse = VITESSE_GHOST;
    _move = move; // permet de faire sortir clyde de la zone des fantomes
    _cacheMove = cacheMove;
    _direction = direction;
    _directions.add(directions1);
    _directions.add(directions2);
  }

  // pour les commentaires de cette partie se référé aussi à la classe Hero et Blinky //

  @Override
  void update() {
    frightenedMode();
    if (millis() - _game._timeNoPause >= 5000 || _passage) {
      super.update();
    }
  }

  void frightenedMode() {
    if (_frightened) {
      _vitesse = 0.025;
      _color = BLUE;
    } else {
      _vitesse = VITESSE_GHOST;
      _color = ORANGE;
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
