class Game
{
  Board _board;
  Hero _hero;
  Blinky _blinky;
  Clyde _clyde;
  Inky _inky;
  Pinky _pinky;

  String _levelName;
  int _savedTime;

  Game() {
    _board = new Board();
    _hero = new Hero(_board);
    _blinky = new Blinky(_board);
    _clyde = new Clyde(_board);
    _inky = new Inky(_board);
    _pinky = new Pinky(_board);
    _savedTime = 0;
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
    overpoweredPhase();
    touch();
  }

  void drawIt() {
    _board.drawIt();
  }

  void touch() {
    if (conditionTouch(_blinky)) {
      if (_hero._overpowered) {  // si j'ai un mangé un superdot alors je peux manger un fantome 
        println("miam");
        _blinky = new Blinky(_board);
      } else {
        exit(); // meurs
      }
    }
    if (conditionTouch(_inky)) {
      if (_hero._overpowered) {  
        _inky = new Inky(_board);
      } else {
        exit(); // meurs
      }
    }
    if (conditionTouch(_pinky)) {
      // mourrir ou manger le fantome
      if (_hero._overpowered) {  // si j'ai un mangé un superdot alors le timer de 10s se lance
        println("miam");
        _pinky = new Pinky(_board);
      } else {
        exit(); // meurs
      }
    }
    if (conditionTouch(_clyde)) {
      // mourrir ou manger le fantome
      if (_hero._overpowered) {  // si j'ai un mangé un superdot alors le timer de 10s se lance
        println("miam");
        _clyde = new Clyde(_board);
      } else {
        exit(); // meurs
      }
    }
  }

  void overpoweredPhase() { // FRIGHTENED phase (pacman peut manger les fantomes)
    if (_hero._overpowered) { // si j'ai rammasé un superdot alors mon pacman change d'etat
      if (_savedTime == 0) { // je start le timer de ma phase
        _savedTime = millis();
        VITESSE_GHOST = 0.025; 
      }
      int tempsPasse = millis() - _savedTime; // a chaque fois je rentre dans la fonction temps passe augmente
      if (tempsPasse > SUPER_DOT_TIME_LIMIT) { // si le tempsPasse est plus grand que la durée de ma FRIGHTENED
        _hero._overpowered = false;
        VITESSE_GHOST = 0.05; 
        _savedTime = 0;  // je reintinialise le savedtime
      }
    }
  }

  //--------- fonctions qui permettent de savoir quand un des fantomes touche pacman ---------//

  boolean conditionTouch(Blinky _ghost) {
    // dans touchLeft je regarde quand l'extremité gauche de Pacman touche la partie droite du fantomes
    boolean touchLeft = (_ghost._position.x <= _hero._position.x - (GHOST_WIDTH*0.5)) && (_hero._position.x - (GHOST_WIDTH*0.5) <= _ghost._position.x + (GHOST_WIDTH*0.5));
    // touchRight je regarde quand l'extremité droite de Pacman touche la partie gauche du fantomes
    boolean touchRight = (_ghost._position.x >= _hero._position.x + (GHOST_WIDTH*0.5) && _hero._position.x + (GHOST_WIDTH*0.5) >= _ghost._position.x - (GHOST_WIDTH*0.5));
    // samePosY permet de savoir si le fantome et pacman sont sur la même colonne
    boolean samePosY = _ghost._position.y + 2 >= _hero._position.y &&  _ghost._position.y - 2 <= _hero._position.y;
    // les autres fonctions reprennent le schéma précédent
    boolean touchUp = (_hero._position.y - (GHOST_HEIGHT*0.5) >= _ghost._position.y) && (_hero._position.y - (GHOST_HEIGHT*0.5) <= _ghost._position.y + (GHOST_HEIGHT*0.5));
    boolean touchDown = (_hero._position.y + (GHOST_HEIGHT*0.5) <= _ghost._position.y) && (_hero._position.y + (GHOST_HEIGHT) >= _ghost._position.y - (GHOST_HEIGHT*0.5));
    boolean samePosX = _ghost._position.x + 2 >= _hero._position.x &&  _ghost._position.x - 2 <= _hero._position.x;
    return ((samePosY && (touchLeft || touchRight)) || (samePosX && (touchDown || touchUp))); // condtitions finale pour savoir quand Pacman touche un fantôme
  }

  //overload de la fonctions conditionTouch pour être utilisé par tous les fantomes qui sont de classes différentes

  boolean conditionTouch(Inky _ghost) {
    boolean touchLeft = (_ghost._position.x <= _hero._position.x - (GHOST_WIDTH*0.5)) && (_hero._position.x - (GHOST_WIDTH*0.5) <= _ghost._position.x + (GHOST_WIDTH*0.5));
    boolean touchRight = (_ghost._position.x >= _hero._position.x + (GHOST_WIDTH*0.5) && _hero._position.x + (GHOST_WIDTH*0.5) >= _ghost._position.x - (GHOST_WIDTH*0.5));
    boolean samePosY = _ghost._position.y + 2 >= _hero._position.y &&  _ghost._position.y - 2 <= _hero._position.y;
    boolean touchUp = (_hero._position.y - (GHOST_HEIGHT*0.5) >= _ghost._position.y) && (_hero._position.y - (GHOST_HEIGHT*0.5) <= _ghost._position.y + (GHOST_HEIGHT*0.5));
    boolean touchDown = (_hero._position.y + (GHOST_HEIGHT*0.5) <= _ghost._position.y) && (_hero._position.y + (GHOST_HEIGHT) >= _ghost._position.y - (GHOST_HEIGHT*0.5));
    boolean samePosX = _ghost._position.x + 2 >= _hero._position.x &&  _ghost._position.x - 2 <= _hero._position.x;
    return ((samePosY && (touchLeft || touchRight)) || (samePosX && (touchDown || touchUp)));
  }

  boolean conditionTouch(Clyde _ghost) {
    boolean touchLeft = (_ghost._position.x <= _hero._position.x - (GHOST_WIDTH*0.5)) && (_hero._position.x - (GHOST_WIDTH*0.5) <= _ghost._position.x + (GHOST_WIDTH*0.5));
    boolean touchRight = (_ghost._position.x >= _hero._position.x + (GHOST_WIDTH*0.5) && _hero._position.x + (GHOST_WIDTH*0.5) >= _ghost._position.x - (GHOST_WIDTH*0.5));
    boolean samePosY = _ghost._position.y + 2 >= _hero._position.y &&  _ghost._position.y - 2 <= _hero._position.y;
    boolean touchUp = (_hero._position.y - (GHOST_HEIGHT*0.5) >= _ghost._position.y) && (_hero._position.y - (GHOST_HEIGHT*0.5) <= _ghost._position.y + (GHOST_HEIGHT*0.5));
    boolean touchDown = (_hero._position.y + (GHOST_HEIGHT*0.5) <= _ghost._position.y) && (_hero._position.y + (GHOST_HEIGHT) >= _ghost._position.y - (GHOST_HEIGHT*0.5));
    boolean samePosX = _ghost._position.x + 2 >= _hero._position.x &&  _ghost._position.x - 2 <= _hero._position.x;
    return ((samePosY && (touchLeft || touchRight)) || (samePosX && (touchDown || touchUp)));
  }

  boolean conditionTouch(Pinky _ghost) {
    boolean touchLeft = (_ghost._position.x <= _hero._position.x - (GHOST_WIDTH*0.5)) && (_hero._position.x - (GHOST_WIDTH*0.5) <= _ghost._position.x + (GHOST_WIDTH*0.5));
    boolean touchRight = (_ghost._position.x >= _hero._position.x + (GHOST_WIDTH*0.5) && _hero._position.x + (GHOST_WIDTH*0.5) >= _ghost._position.x - (GHOST_WIDTH*0.5));
    boolean samePosY = _ghost._position.y + 2 >= _hero._position.y &&  _ghost._position.y - 2 <= _hero._position.y;
    boolean touchUp = (_hero._position.y - (GHOST_HEIGHT*0.5) >= _ghost._position.y) && (_hero._position.y - (GHOST_HEIGHT*0.5) <= _ghost._position.y + (GHOST_HEIGHT*0.5));
    boolean touchDown = (_hero._position.y + (GHOST_HEIGHT*0.5) <= _ghost._position.y) && (_hero._position.y + (GHOST_HEIGHT) >= _ghost._position.y - (GHOST_HEIGHT*0.5));
    boolean samePosX = _ghost._position.x + 2 >= _hero._position.x &&  _ghost._position.x - 2 <= _hero._position.x;
    return ((samePosY && (touchLeft || touchRight)) || (samePosX && (touchDown || touchUp)));
  }

  // fonctionne qui permet de savoir quelle touche j'ai appuyé lors du jeu et créée le _hero._move //

  void handleKey(int key) {

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
