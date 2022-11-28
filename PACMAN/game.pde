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

  void handleKey(int key) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        float target = (width / _board._nbCellsX) * (_hero._cellY + CENTRAGE_POSX - 1);
        float difference = CELL_SIZE_X;
        _hero._position.x -= difference * VITESSE_HERO;
        if (_hero._position.x <= target){
          _hero.moveLeft(); 
          _hero._position.x = target; 
        }
      }
      if (keyCode == RIGHT) {
        float target = (width / _board._nbCellsX) * (_hero._cellY + CENTRAGE_POSX + 1);
        float difference = target - _hero._position.x;
        _hero._position.x += difference * VITESSE_HERO;
        _hero.moveRight();
      }
      if (keyCode == UP) {
        float target = height * 0.9 / _board._nbCellsY * (_hero._cellX + CENTRAGE_POSY - 1) + height * 0.1;
        float difference = _hero._position.y - target;
        _hero._position.y -= difference * VITESSE_HERO;
        _hero.moveUp();
      }
      if (keyCode == DOWN) {
        float target = height * 0.9 / _board._nbCellsY * (_hero._cellX + CENTRAGE_POSY + 1) + height * 0.1;
        float difference = target - _hero._position.y;
        _hero._position.y += difference * VITESSE_HERO;
        _hero.moveDown();
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
