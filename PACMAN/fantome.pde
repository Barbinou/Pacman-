public class Fantome {

  Board _board;
  Hero _hero;
  int _cellX, _cellY, _move, _cacheMove;
  PVector _position, _direction;
  List <Integer> _directions; // je crée une copie des mouvements possibles par le fantome
  boolean _frightened, _passage;
  float _vitesse;
  color _color;

  Fantome(Board b, Hero h) {
    _board = b;
    _hero = h;
    _directions = new ArrayList <>(DIRECTIONS);
    _frightened = false;
    _passage = false;
    _vitesse = VITESSE_GHOST;
    _direction = new PVector (0, 0);
  }

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

  void drawIt() {
    if (!_frightened) {
      switch(_move) {
      case RIGHT:
        image(sprites.get(0), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      case DOWN:
        image(sprites.get(36), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      case LEFT:
        image(sprites.get(72), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      case UP:
        image(sprites.get(108), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
        break;
      }
    }
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

  void updateCells() { // deplace Blinky sur la grille
    _cellX += (int)_direction.x;
    _cellY += (int)_direction.y;
  }

  void move(float target) {
    try {
      switch(_board._cells[_cellX + (int)_direction.x][_cellY + (int) _direction.y]) { // je regarde la case devant moi
      case WALL : // si la case est un WALL ou une DOOR
        wallGestion(target);
        break;
      case DOOR :
        if (!_passage) {  // gestion de la porte ouverture que dans un sens
          _passage = true;
          cacheMove();
          break;
        }
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
        updateCells();
      }
      break;
    case RIGHT:
      if (_board._cells[_cellX][_cellY + 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCells();
      }
      break;
    case DOWN:
      if (_board._cells[_cellX + 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCells();
      }
      break;
    case LEFT:
      if (_board._cells[_cellX][_cellY - 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCells();
      }
      break;
    default: // si je n'ai pas de _cacheMove alors j'en crée un nouveau
      randomMove();
      updateCells();
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
      image(sprites.get(216), (_position.x + _board._offset.x) - CELL_SIZE_X / 3.4, _position.y  - CELL_SIZE_Y / 4, GHOST_WIDTH*1.5, GHOST_HEIGHT*1.5);
    } else {
      _vitesse = VITESSE_GHOST;
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
}
