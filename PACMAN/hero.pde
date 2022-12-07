class Hero {
  // position on screen
  PVector _posOffset, _position;
  // position on board
  int _cellX, _cellY, _cacheMove, _move, _life, _score;
  // display size
  float _size;

  PFont _scoreFont; // nouvelle PFont pour avoir une font différente

  Board _board;

  PVector _direction;
  boolean _moving, _overpowered; // is moving ?

  Hero(Board b) {  // constructeur de hero
    _board = b;
    _overpowered = false; 
    getCellHero();
    _life = 3;
    _score = 0;
    _direction = new PVector (0, 0);
    _position = new PVector ((width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX), height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1); //position de PACMAN recupere
    _scoreFont = createFont("score.TTF", 128); // je créée ma font
  }

  void launchMove(PVector dir) {
  }

  void move(float target) {
    try {
      switch(_board._cells[_cellX + (int)_direction.x][_cellY + (int) _direction.y]) { // je regarde la case devant moi
      case WALL : // si la case est un mur
        if (_move == RIGHT || _move == LEFT) {  // permet a PACMAN de rester à sa position quand il est devant un mur
          _position.x = target;
        } else {
          _position.y = target;
        }
        if (_cacheMove != 0) { // si le cache n'est pas vide alors je le vide
          deleteCacheMove();
        }
        break;
      default: // si la case n'est pas un mur
        eat(); 
        cacheMove(); 
      }
    }
    catch(ArrayIndexOutOfBoundsException e) {  // gestion de l'erreur OutOfBounds pour replacer mon PACMAN
      eat();
      if (e.toString().equals(ERROR)) { // si PACMAN est OutOfBounds à gauche alors je le repositionne à droite et inversement
        _position.x = width;
        _cellY = 22;
      } else {
        _position.x = 0;
        _cellY = 0;
      }
    }
  }

  void cacheMove() {  // gestion du mouvement cache
    switch (_cacheMove) { // regarde si la casse corespondante au _cacheMove n'est pas un WALL pour se diriger dans le sens de _cacheMove au lieu de _move
    case UP:
      if (_board._cells[_cellX - 1][_cellY] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    case RIGHT:
      if (_board._cells[_cellX][_cellY + 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    case DOWN:
      if (_board._cells[_cellX + 1][_cellY] != TypeCell.WALL && _board._cells[_cellX + 1][_cellY] != TypeCell.DOOR) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    case LEFT:
      if ( _board._cells[_cellX][_cellY - 1] != TypeCell.WALL) {
        deleteCacheMove();
      } else {
        updateCellsHero();
      }
      break;
    default:
      updateCellsHero();
    }
  }

  void eat() { // mange la cellule
    switch(_board._cells[_cellX][_cellY]) {
    case DOT:
      _board._cells[_cellX][_cellY] = TypeCell.EMPTY;
      _score += SCORE_DOT;
      break;
    case SUPER_DOT:
      _board._cells[_cellX][_cellY] = TypeCell.EMPTY;
      _score += SCORE_SUPER_DOT;
      _overpowered = true; 
      break; 
    }
  }

  void deleteCacheMove() { // supprime la derniere action de l'utilisateur
    _move = _cacheMove;
    _cacheMove = 0;
  }

  void update() {
    float targetX = (width / _board._nbCellsX) * (_cellY + CENTRAGE_POSX);  // differentes cibles que doit atteindre PACMAN en fonction de _move
    float targetY = height * 0.9 / _board._nbCellsY * (_cellX + CENTRAGE_POSY) + height * 0.1;

    switch (_move) {
    case LEFT:
      _direction.set(0, -1); // je set la direction qui correspond au _move
      _position.x -= CELL_SIZE_X * VITESSE_HERO; // animation deplacmeent de PACMAN
      if (_position.x <= targetX) { // si PACMAN à atteint sa cible ou là dépassé
        move(targetX); // PACMAN passe à la case suivante
      }
      break;
    case RIGHT:
      _direction.set(0, 1);
      _position.x += CELL_SIZE_X * VITESSE_HERO;
      if (_position.x >= targetX) {
        move(targetX);
      }
      break;
    case UP:
      _direction.set(-1, 0);
      _position.y -= CELL_SIZE_X * VITESSE_HERO;
      if (_position.y <= targetY) {
        move(targetY);
      }
      break;
    case DOWN:
      _direction.set(1, 0);
      _position.y += CELL_SIZE_X * VITESSE_HERO;
      if (_position.y >= targetY) {
        move(targetY);
      }
      break;
    }
    drawIt(); // on redessine
  }

  void updateCellsHero() { // deplace PACMAN sur la grille
    _cellX += (int)_direction.x;
    _cellY += (int)_direction.y;
  }

  void drawIt() {
    drawPacman();
    drawLife();
    drawScore();
  }

  void drawPacman () {
    noStroke();
    fill(YELLOW);
    ellipse(_position.x + _board._offset.x, _position.y, (width /_board._nbCellsY)*0.5, (height / _board._nbCellsX)*0.5); // PACMAN
  }

  void drawLife() { // dessine la vie
    textAlign(RIGHT, CENTER);  // j'aligne ma vie à droite et au centre
    textFont(_scoreFont); // j'applique la font
    textSize(CELL_SIZE_X*0.5); // taille de la font
    text(String.format("Vie : %d", _life), width - _board._offset.x, height*0.05); // string.format gère la concatenation et %d correspond à un int
  }

  void drawScore() { // même chose que pour la vie à quelques paramètres près
    textAlign(LEFT, CENTER);
    textFont(_scoreFont);
    textSize(CELL_SIZE_X*0.5);
    text(String.format("Score : %d", _score), _board._offset.x, height*0.05);
  }

  void getCellHero() { // permet de retouver la posX et Y de pacman dans la grille
    for (int x = 0; x < _board._cells.length; x++) {
      for (int y = 0; y < _board._cells[x].length; y++) {
        switch (_board._cells[x][y]) {
        case PACMAN:
          _cellX = x;
          _cellY = y;
        }
      }
    }
  }
}
