class Game
{
  Board _board;
  Hero _hero;
  Blinky _blinky;
  Clyde _clyde;
  Inky _inky;
  Pinky _pinky;

  String _levelName;

  Game() {
    _board = new Board();
    _hero = new Hero(_board);
    _blinky = new Blinky(_board);
    _clyde = new Clyde(_board);
    _inky = new Inky(_board);
    _pinky = new Pinky(_board);
  }

  void update() {
    _hero.update();
    _blinky.update();
    _clyde.drawIt();
    _inky.drawIt();
    _pinky.drawIt();
    if (millis() >= 5000) { // si la partie à plus de 5s alors mon _clyde bouge 
      _clyde.update();
    }
    if (millis() >= 10000) { // si la partie à plus de 10s alors mon _inky bouge
      _inky.update();
    }
    if (millis() >= 15000) { // si la partie à plus de 15s alors mon _pinky bouge
      _pinky.update();
    }
  }

  void drawIt() {
    _board.drawIt();
  }

  void handleKey(int key) { // fonctionne qui permet de savoir quelle touche j'ai appuyé lors du jeu est crée le _hero._move

    float targetX = (width / _board._nbCellsX) * (_hero._cellY + CENTRAGE_POSX); // targets pour savoir le millieu de la cellule
    float targetY = height * 0.9 / _board._nbCellsY * (_hero._cellX + CENTRAGE_POSY) + height * 0.1;

    if (key == CODED || KEYS.contains(key)) { // si la clé est codée ou qu'elle appartient à la liste keys

      if (keyCode == LEFT || key == 'q') {
        if (_board._cells[_hero._cellX][_hero._cellY - 1] != TypeCell.WALL && _hero._position.y == targetY) { // si la case suivante n'est pas un mur et que PACMAN et au millieu de la cellule
          _hero._move = LEFT; // si le mouvement est possbile 
        } else {
          _hero._cacheMove = LEFT; // si le mouvement n'est pas possible 
        }
      }

      if (keyCode == RIGHT || key == 'd') {
        if (_board._cells[_hero._cellX][_hero._cellY + 1] != TypeCell.WALL && _hero._position.y == targetY) {
          _hero._move = RIGHT;
        } else {
          _hero._cacheMove = RIGHT;
        }
      }

      if (keyCode == UP || key == 'z') {
        if (_board._cells[_hero._cellX - 1][_hero._cellY] != TypeCell.WALL && _hero._position.x == targetX) {
          _hero._move = UP;
        } else {
          _hero._cacheMove = UP;
        }
      }

      if (keyCode == DOWN || key == 's') {
        if ( _board._cells[_hero._cellX + 1][_hero._cellY] != TypeCell.WALL && _hero._position.x == targetX) {
          _hero._move = DOWN;
        } else {
          _hero._cacheMove = DOWN;
        }
      }
    }
  }
}
