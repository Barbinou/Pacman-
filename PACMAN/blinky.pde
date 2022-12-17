public class Blinky extends Fantome {

  Blinky(Board b, Hero h) {
    super(b, h);
    _color = RED;
    _passage = true; 
    _move = RIGHT; // premier mouvement de blinky
    getCellBlinky();
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1); //position de PACMAN recupere
  }

  Blinky(Board b, Hero h, PVector position, boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX, int cellY) {
    super(b, h);
    _board = b;
    _hero = h;
    _position = position;
    _cellY = cellY;
    _cellX = cellX;
    _color = RED;
    _frightened = frightened;
    _move = move; // premier mouvement de blinky
    _cacheMove = cacheMove;
    _vitesse = VITESSE_GHOST;
    _directions.add(directions1);
    _directions.add(directions2);
    _direction = direction;
    _passage = true; 
  }

  void getCellBlinky() {
    for (int x = 0; x < _board._cells.length; x++) {
      for (int y = 0; y < _board._cells[x].length; y++) {
        switch (_board._cells[x][y]) {
        case BLINKY:
          _cellX = x;
          _cellY = y;
        }
      }
    }
  }
}
