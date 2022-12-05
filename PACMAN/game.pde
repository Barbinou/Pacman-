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
    _hero.update();
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
          _hero._move = LEFT;
        } else {
          _hero._cacheMove = LEFT;
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
