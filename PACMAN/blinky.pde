class Blinky {

  Board _board;
  Hero _hero;
  int _cellX, _cellY, _move, _cacheMove;
  PVector _position, _direction;
  List <Integer> _directions; // je crée une copie des mouvements possibles par le fantome
  boolean _frightened;
  float _vitesse;
  color _color;

  Blinky(Board b, Hero h) {
    _board = b;
    _hero = h;
    _directions = new ArrayList <>(DIRECTIONS);
    _color = RED;
    _frightened = false;
    _move = RIGHT; // premier mouvement de blinky
    getCellBlinky();
    _vitesse = VITESSE_GHOST;
    _direction = new PVector (0, 0);
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1); //position de PACMAN recupere
  }

  Blinky(Board b, Hero h, PVector position, boolean frightened, int move, int cacheMove, PVector direction, int directions1, int directions2, int cellX, int cellY) {
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
    _directions = new ArrayList<>();
    _directions.add(directions1);
    _directions.add(directions2);
    _direction = direction;
  }

  // pour les commentaires de cette partie se référé aussi à la classe Hero //

  void update() {
    frightenedMode();
    float targetX = (width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX);
    float targetY = height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1;
    switch (_move) {
    case LEFT:
      _direction.set(0, -1);
      _position.x -= CELL_SIZE_X * _vitesse;
      if (_position.x <= targetX) {
        _position.x = targetX;
        move(targetX);
      }
      break;
    case RIGHT:
      _direction.set(0, 1);
      _position.x += CELL_SIZE_X * _vitesse;
      if (_position.x >= targetX) {
        _position.x = targetX;
        move(targetX);
      }
      break;
    case UP:
      _direction.set(-1, 0);
      _position.y -= CELL_SIZE_X * _vitesse;
      if (_position.y <= targetY) {
        _position.y = targetY;
        move(targetY);
      }
      break;
    case DOWN:
      _direction.set(1, 0);
      _position.y += CELL_SIZE_X * _vitesse;
      if (_position.y >= targetY) {
        _position.y = targetY;
        move(targetY);
      }
      break;
    }
  }

  void drawIt() { // dessine blinky
    noStroke();
    fill(_color);
    ellipse(_position.x + _board._offset.x, _position.y, GHOST_WIDTH, GHOST_HEIGHT);
  }

  void randomMove() { // permet d'avoir les mouvements possible du fantomes
    _directions = new ArrayList <>(DIRECTIONS);
    Collections.shuffle(_directions, new Random()); // je mélange mon ArrayList de directions
    switch (_move) { // je ban le mouvement précédent de mon ArrayList
    case LEFT:
      _directions.remove(Integer.valueOf(RIGHT));
      break;
    case RIGHT:
      _directions.remove(Integer.valueOf(LEFT));
      break;
    case UP:
      _directions.remove(Integer.valueOf(DOWN));
      break;
    case DOWN:
      _directions.remove(Integer.valueOf(UP));
      break;
    }
    _cacheMove = _directions.get(0); // je prends le premier element de ma liste
    _directions.remove(0); // et je l'enlève de la liste
  }

  void updateCellsBlinky() { // deplace Blinky sur la grille
    _cellX += (int)_direction.x;
    _cellY += (int)_direction.y;
  }

  void move(float target) {
    try {
      switch(_board._cells[_cellX + (int)_direction.x][_cellY + (int) _direction.y]) { // je regarde la case devant moi
      case DOOR :
      case WALL : // si la case est un WALL ou une DOOR
        wallGestion(target);
        break;
      default: // si la case n'est pas un mur
        cacheMove();
      }
    }
    catch(ArrayIndexOutOfBoundsException e) {  // gestion de l'erreur OutOfBounds pour replacer mon Blinky
      if (e.toString().equals(ERROR)) { // si Blinky est OutOfBounds à gauche alors je le repositionne à droite et inversement
        _position.x = width;
        _cellY = 22;
      } else {
        _position.x = 0;
        _cellY = 0;
      }
    }
  }

  void cacheMove() {
    if (_directions.isEmpty()) { // si mon ArrayList est vide alors je rechoisis des mouvements
      randomMove();
    }
    switch (_cacheMove) { // regarde si la casse corespondante au _cacheMove n'est pas un WALL pour se diriger dans le sens de _cacheMove au lieu de _move
    case UP:
      if (_board._cells[_cellX - 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsBlinky();
      }
      break;
    case RIGHT:
      if (_board._cells[_cellX][_cellY + 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsBlinky();
      }
      break;
    case DOWN:
      if (_board._cells[_cellX + 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsBlinky();
      }
      break;
    case LEFT:
      if (_board._cells[_cellX][_cellY - 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsBlinky();
      }
      break;
    default: // si je n'ai pas de _cacheMove alors j'en crée un nouveau
      randomMove();
      updateCellsBlinky();
    }
  }

  void deleteCacheMove() { // supprime la derniere action de l'utilisateur
    _move = _cacheMove;
    _cacheMove = 0;
  }

  void wallGestion(float target) {
    if (_move == RIGHT || _move == LEFT) {  // permet a Blinky de ne pas depasser le mur
      _position.x = target;
      goodMove();
    } else {
      _position.y = target;
      goodMove();
    }
    if (_cacheMove != 0) { // si le cache n'est pas vide alors je le vide
      deleteCacheMove();
    }
  }

  void goodMove() { // permet à Blinky de changer de cacheMove si celui-ci le fait rester devant mur
    if (_cacheMove == 0) {
      _cacheMove = _directions.get(0);
      _directions.remove(0);
    }
  }

  void frightenedMode() { // changement d'apparence et de vitesse lors du FRIGHTENED
    if (_frightened) {
      _vitesse = 0.025;
      _color = BLUE;
    } else {
      _vitesse = VITESSE_GHOST;
      _color = RED;
    }
  }

  //--------- fonctions qui permettent de savoir quand un des fantomes touche pacman ---------//

  boolean conditionTouch() {
    // dans touchLeft je regarde quand l'extremité gauche de Pacman touche la partie droite du fantomes
    boolean touchLeft = (_position.x <= _hero._position.x - (GHOST_WIDTH*0.5)) && (_hero._position.x - (GHOST_WIDTH*0.5) <= _position.x + (GHOST_WIDTH*0.5));
    // touchRight je regarde quand l'extremité droite de Pacman touche la partie gauche du fantomes
    boolean touchRight = (_position.x >= _hero._position.x + (GHOST_WIDTH*0.5) && _hero._position.x + (GHOST_WIDTH*0.5) >= _position.x - (GHOST_WIDTH*0.5));
    // samePosY permet de savoir si le fantome et pacman sont sur la même colonne
    boolean samePosY = _position.y + 2 >= _hero._position.y && _position.y - 2 <= _hero._position.y;
    // les autres fonctions reprennent le schéma précédent
    boolean touchUp = (_hero._position.y - (GHOST_HEIGHT*0.5) >= _position.y) && (_hero._position.y - (GHOST_HEIGHT*0.5) <= _position.y + (GHOST_HEIGHT*0.5));
    boolean touchDown = (_hero._position.y + (GHOST_HEIGHT*0.5) <= _position.y) && (_hero._position.y + (GHOST_HEIGHT) >= _position.y - (GHOST_HEIGHT*0.5));
    boolean samePosX = _position.x + 2 >= _hero._position.x && _position.x - 2 <= _hero._position.x;
    return ((samePosY && (touchLeft || touchRight)) || (samePosX && (touchDown || touchUp))); // condtitions finale pour savoir quand Pacman touche un fantôme
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
