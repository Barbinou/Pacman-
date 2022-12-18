class Game {
  Board _board;
  Menu _menu;
  Hero _hero;
  Blinky _blinky;
  Clyde _clyde;
  Inky _inky;
  Pinky _pinky;
  SoundFile file;
  Fruits _fruit;

  GameState _gameState;
  String _levelName, _path;
  int _savedTime;
  float _savedSD, _timeNoPause;
  List <Integer> _ghostScore;
  ArrayList <Fantome> _fantomes = new ArrayList <>();
  boolean _musicF, _musicC, _gamePaused, _gameRetry, _gameEnd, _gameRecover; //permet de lancer une seule fois la music au lieu de la lancer en continue
  String[] _rawData = loadStrings(BOARD_CREATE_FILE);

  Game(String path) {
    _board = new Board(_rawData);
    _hero = new Hero(_board);
    _blinky = new Blinky(_board, _hero);
    _clyde = new Clyde(_board, _hero);
    _inky = new Inky(_board, _hero);
    _pinky = new Pinky(_board, _hero);
    _menu = new Menu(this, _board);
    _fruit = new Fruits (_board, _hero);
    _savedTime = 0; // temps sauvegardé pour la gestion du FRIGHTENED
    // quelle musique se lance
    _musicF = false;
    _musicC = true;
    // differents états de la partie
    _gamePaused = false;
    _gameRetry = false;
    _gameEnd = false;
    _gameRecover = false;
    _gameState = GameState.CHASE;
    _path = path; // chemin absolu pour la sauvegarde
    createListGhost(_fantomes);
  }

  Game(String path, Board board, int heroLife, int heroScore, boolean musicC) {
    _board = board;
    _hero = new Hero(_board);
    _blinky = new Blinky(_board, _hero);
    _clyde = new Clyde(_board, _hero);
    _inky = new Inky(_board, _hero);
    _pinky = new Pinky(_board, _hero);
    _menu = new Menu(this, _board);
    _fruit = new Fruits (_board, _hero);
    _savedTime = 0;
    _musicF = false;
    _musicC = musicC;
    _gamePaused = false;
    _gameRetry = false;
    _gameEnd = false;
    _gameState = GameState.CHASE;
    _path = path;
    _hero._life = heroLife;
    _hero._score = heroScore;
    createListGhost(_fantomes);
  }

  Game(String path, Board board, Hero hero, Blinky blinky, Inky inky, Pinky pinky, Clyde clyde, Fruits fruit, GameState gameState, float timeNoPause) {
    _board = board;
    _hero = hero;
    _blinky = blinky;
    _clyde = clyde;
    _inky = inky;
    _pinky = pinky;
    _menu = new Menu(this, _board);
    _fruit = fruit;
    _savedTime = 0;
    _musicF = false;
    _musicC = true;
    _gamePaused = false;
    _gameRetry = false;
    _gameEnd = false;
    _gameState = gameState;
    _timeNoPause = timeNoPause;
    _path = path;
    createListGhost(_fantomes);
  }

  void update() {
    if (!_gamePaused && (_gameState != GameState.END)) { // si le jeu est en pause j'arrete l'update
      _hero.update();
      _fantomes.forEach(fantome -> fantome.update());
      frightenedPhase();  // phase FRIGHTENED si SD mangé
      touch(); // si pacman touche un fantome
      victoire();
    } else { // si jeu en pause update du menu
      _menu.drawIt();
    }
  }

  void drawIt() {
    _board.drawIt();
    _hero.drawIt();
    _fantomes.forEach(fantome -> fantome.drawIt());
    _fruit.drawIt();
    drawMode();
  }

  void victoire() {
    if (DOT == 0) {
      _gameState = GameState.END;
    }
  }

  void createListGhost(ArrayList <Fantome> liste) {
    liste.add(_blinky);
    liste.add(_inky);
    liste.add(_pinky);
    liste.add(_clyde);
  }

  void touch() {
    ArrayList <Fantome> ghostList = new ArrayList<>();
    createListGhost(ghostList);
    for (Fantome ghost : ghostList) {
      if (ghost.conditionTouch()) {
        if (_hero._overpowered && ghost._frightened) {
          resetGhost(ghost);
          _hero._score += _ghostScore.remove(0);
        } else if (_hero._life > LAST_LIFE) {
          eatByGhost();
        } else {
          _gameState = GameState.END;
        }
      }
    }
    _fantomes = ghostList;
    // si PACMAN touche un fruit et qu'il est mangeable
    if (_fruit.conditionTouch() && _fruit._eatable) {
      // j'augmente mon score
      _hero._score += SCORE_BONUS;
      // je retire un fruit du nombre total
      _fruit._numberFruits -= 1;
      _fruit._eatable = false;
    }
  }

  void resetGhost(Fantome fantome) {
    if (fantome instanceof Blinky) {
      _blinky = new Blinky (_board, _hero);
    }
    if (fantome instanceof Inky) {
      _inky = new Inky (_board, _hero);
    }
    if (fantome instanceof Pinky) {
      _pinky = new Pinky (_board, _hero);
    }
    if (fantome instanceof Clyde) {
      _clyde = new Clyde (_board, _hero);
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
        _fantomes.forEach(fantome -> fantome._frightened = false);
        _gameState = GameState.CHASE;
        _musicC = true;
        _savedTime = 0;  // je reintinialise le savedtime
      }
    }
  }

  void startFrightened () { // tous les etats de mes objets rentrent en FRIGHTENED
    _savedSD = SUPER_DOT; // rentre en cahce le nombre de superdot pour prolonger la durée du superdot
    _savedTime = millis(); // debut du temps
    _fantomes.forEach(fantome -> fantome._frightened = true);
    _gameState = GameState.FRIGHTENED; // je change de mode
    _musicF = true; // je lance la musqiue correspondante
    _ghostScore = new ArrayList <>(SCORE_GHOST); // copie de scoreGhost (valeurs globales)
  }

  void eatByGhost() { // quand pacman se fait toucher revient au depart avec une vie en moins
    _hero._life -= 1;
    _game = new Game(path.getAbsolutePath(), _board, _hero._life, _hero._score, true);
    _game._menu._time = millis();  // reset du temps
    _game._timeNoPause = millis();
  }

  // fonctionne qui permet de savoir quelle touche j'ai appuyé lors du jeu et créée le _hero._move //

  void handleKey(int key) {

    float targetX = (width / _board._nbCellsX) * (_hero._cellY + CENTRAGE_POSX); // targets pour savoir le millieu de la cellule
    float targetY = height * 0.9 / _board._nbCellsY * (_hero._cellX + CENTRAGE_POSY) + height * 0.1;
    try {
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
    catch (ArrayIndexOutOfBoundsException e) {
      if (e.toString().equals(ERROR)) { // si PACMAN est OutOfBounds à gauche alors je le repositionne à droite et inversement
        _hero._position.x = width;
        _hero._cellY = 22;
      } else {
        _hero._position.x = 0;
        _hero._cellY = 0;
      }
    }
  }

  void drawMode() {
    textAlign(CENTER, CENTER);
    textSize(CELL_SIZE_X*0.8);
    fill(YELLOW);
    text(String.valueOf(_gameState), width/2, height*0.05);
  }

  void saveGame(BufferedWriter writer) { // fonction qui permet de sauvegarder mes données de jeu
    try {
      _timeNoPause = millis();
      writer.write(String.format("\n%s %f _position.y %f _direction.x %f _direction.y %f _overpowered %b _life %d _score %d _cacheLife %d _move %d _cacheMove %d _cellX %d _cellY %d", Object.HERO.getValue(), _hero._position.x, _hero._position.y, _hero._direction.x, _hero._direction.y, _hero._overpowered, _hero._life, _hero._score, _hero._cacheLifeUp, _hero._move, _hero._cacheMove, _hero._cellX, _hero._cellY));
      writer.write(String.format("\n%s %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d", Object.BLINKY.getValue(), _blinky._position.x, _blinky._position.y, _blinky._frightened, _blinky._move, _blinky._cacheMove, _blinky._direction.x, _blinky._direction.y, _blinky._directions.get(0), _blinky._directions.get(1), _blinky._cellX, _blinky._cellY)); // %f pour les floats, %d pour les entiers, %s pour les String et enfin %b pour les booléans
      writer.write(String.format("\n%s %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d _passage %b", Object.INKY.getValue(), _inky._position.x, _inky._position.y, _inky._frightened, _inky._move, _inky._cacheMove, _inky._direction.x, _inky._direction.y, _inky._directions.get(0), _inky._directions.get(1), _inky._cellX, _inky._cellY, _inky._passage));
      writer.write(String.format("\n%s %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d _passage %b", Object.PINKY.getValue(), _pinky._position.x, _pinky._position.y, _pinky._frightened, _pinky._move, _pinky._cacheMove, _pinky._direction.x, _pinky._direction.y, _pinky._directions.get(0), _pinky._directions.get(1), _pinky._cellX, _pinky._cellY, _pinky._passage));
      writer.write(String.format("\n%s %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d _passage %b", Object.CLYDE.getValue(), _clyde._position.x, _clyde._position.y, _clyde._frightened, _pinky._move, _pinky._cacheMove, _clyde._direction.x, _clyde._direction.y, _clyde._directions.get(0), _clyde._directions.get(1), _clyde._cellX, _clyde._cellY, _clyde._passage));
      writer.write(String.format("\n%s %b _numberFruits %d", Object.FRUIT.getValue(), _fruit._eatable, _fruit._numberFruits));
      writer.write(String.format("\n%s %s _timeNoPause %f", Object.GAME.getValue(), _gameState, _timeNoPause));
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}
