class Game

{
  Board _board;
  Hero _hero;
  Blinky _blinky;
  Clyde _clyde;
  Inky _inky;
  Pinky _pinky;
  SoundFile file;

  String _levelName, _gameState;
  int _savedTime;
  float _savedSD;
  List <Integer> _ghostScore;
  boolean _musicF, _musicC; //permet de lancer une seule fois la music au lieu de la lancer en continue

  Game() {
    _board = new Board();
    _hero = new Hero(_board);
    _blinky = new Blinky(_board, _hero);
    _clyde = new Clyde(_board, _hero);
    _inky = new Inky(_board, _hero);
    _pinky = new Pinky(_board, _hero);
    _savedTime = 0;
    _musicF = false;
    _musicC = true;
    _gameState = "CHASE"; // etat de la partie
  }

  void update() {
    victory(); 
    _hero.update();
    _blinky.update();
    _inky.update();
    _pinky.update();
    _clyde.update();
    frightenedPhase();  // phase FRIGHTENED si SD mangé
    touch(); // si pacman touche un fantome
  }

  void drawIt() {
    _board.drawIt();
  }

  void touch() {
    if (_blinky.conditionTouch()) {
      if (_hero._overpowered && _blinky._frightened) {  // si j'ai un mangé un superdot et que le fantome est mangeable
        _blinky = new Blinky(_board, _hero); // mon blinky meurs et reviens à sa position de départ
        _hero._score += _ghostScore.remove(0); // chaque fois que je mange un fantome j'enleve de ma liste la premiere valeur
      } else {
        _hero._life -= 1; // meurs
      }
    }
    if (_inky.conditionTouch()) {
      if (_hero._overpowered && _inky._frightened) {
        _inky = new Inky(_board, _hero);
        _hero._score += _ghostScore.remove(0);
      } else {
        _hero._life -= 1;
      }
    }
    if (_pinky.conditionTouch()) {
      if (_hero._overpowered && _pinky._frightened) {
        _pinky = new Pinky(_board, _hero);
        _hero._score += _ghostScore.remove(0);
      } else {
        _hero._life -= 1;
      }
    }
    if (_clyde.conditionTouch()) {
      if (_hero._overpowered && _clyde._frightened) {
        _clyde = new Clyde(_board, _hero);
        _hero._score += _ghostScore.remove(0);
      } else {
        _hero._life -= 1;
      }
    }
  }

  void frightenedPhase() { // FRIGHTENED phase (pacman peut manger les fantomes)
    if (_hero._overpowered) { // si j'ai rammasé un superdot alors mon pacman change d'etat
      if (_savedTime == 0) { // je start le timer de ma phase
        startFrightened();
      }
      if (_savedSD > SUPER_DOT) { // si je ramasse une SD alors je prolonge la durée de SD
        startFrightened();
      }
      int tempsPasse = millis() - _savedTime; // a chaque fois je rentre dans la fonction temps passe augmente
      if (tempsPasse > SUPER_DOT_TIME_LIMIT) { // si le tempsPasse est plus grand que la durée de ma FRIGHTENED
        _hero._overpowered = false;
        _blinky._frightened = false;
        _clyde._frightened = false;
        _inky._frightened = false;
        _pinky._frightened = false;
        _gameState = "CHASE";
        _musicC = true;
        _savedTime = 0;  // je reintinialise le savedtime
      }
    }
  }

  void startFrightened () { // tous les etats de mes objets rentrent en FRIGHTENED
    _savedSD = SUPER_DOT; // rentre en cahce le nombre de superdot pour prolonger la durée du superdot
    _savedTime = millis(); // debut du temps
    _blinky._frightened = true;
    _clyde._frightened = true;
    _inky._frightened = true;
    _pinky._frightened = true;
    _gameState = "FRIGHTENED"; // je change de mode
    _musicF = true; // je lance la musqiue correspondante
    _ghostScore = new ArrayList <>(SCORE_GHOST); // copie de scoreGhost (valeurs globales)
  }
  
  void victory(){
    if(_hero._life == 0){
      println("loose"); // faire un popup
    }
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
