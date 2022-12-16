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

  String _levelName, _gameState, _path;
  int _savedTime;
  float _savedSD, _timeNoPause;
  List <Integer> _ghostScore;
  boolean _musicF, _musicC, _gamePaused, _gameRetry, _gameEnd; //permet de lancer une seule fois la music au lieu de la lancer en continue
  String[] _rawData = loadStrings("levels/level1.txt");

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
    _musicF = false;
    _musicC = true;
    _gamePaused = false; // le jeu est en pause
    _gameRetry = false;  // si je recommence
    _gameEnd = false;
    _gameState = "CHASE"; // etat de la partie
    _path = path; // chemin absolu pour la sauvegarde
  }

  Game(String path, Board board, int heroLife, int heroScore) {
    _board = board;
    _hero = new Hero(_board);
    _blinky = new Blinky(_board, _hero);
    _clyde = new Clyde(_board, _hero);
    _inky = new Inky(_board, _hero);
    _pinky = new Pinky(_board, _hero);
    _menu = new Menu(this, _board);
    _fruit = new Fruits (_board, _hero); 
    _savedTime = 0; // temps sauvegardé pour la gestion du FRIGHTENED
    _musicF = false;
    _musicC = false;
    _gamePaused = false; // le jeu est en pause
    _gameRetry = false;  // si je recommence
    _gameEnd = false;
    _gameState = "CHASE"; // etat de la partie
    _path = path; // chemin absolu pour la sauvegarde
    _hero._life = heroLife;
    _hero._score = heroScore;
  }

  Game(String path, Board board, Hero hero, Blinky blinky, Inky inky, Pinky pinky, Clyde clyde, Fruits fruit, String gameState, float timeNoPause) {
    _board = board;
    _hero = hero;
    _blinky = blinky;
    _clyde = clyde;
    _inky = inky;
    _pinky = pinky;
    _menu = new Menu(this, _board);
    _fruit = fruit; 
    _savedTime = 0; // temps sauvegardé pour la gestion du FRIGHTENED
    _musicF = false;
    _musicC = true;
    _gamePaused = false; // le jeu est en pause
    _gameRetry = false;  // si je recommence
    _gameEnd = false;
    _gameState = gameState; // etat de la partie
    _timeNoPause = timeNoPause;
    _path = path; // chemin absolu pour la sauvegarde
  }

  void update() {
    if (!_gamePaused && !_gameState.equals("END")) { // si le jeu est en pause j'arrete l'update
      _hero.update();
      _blinky.update();
      _inky.update();
      _pinky.update();
      _clyde.update();
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
    _blinky.drawIt();
    _inky.drawIt();
    _pinky.drawIt();
    _clyde.drawIt();
    _fruit.drawIt(); 
    drawMode(); 
  }

  void victoire() {
    if (DOT == 0) {
      _gameState = "END";
    }
  }

  void touch() {
    if (_blinky.conditionTouch()) {
      if (_hero._overpowered && _blinky._frightened) {  // si j'ai un mangé un superdot et que le fantome est mangeable
        _blinky = new Blinky(_board, _hero); // mon blinky meurs et reviens à sa position de départ
        _hero._score += _ghostScore.remove(0); // chaque fois que je mange un fantome j'enleve de ma liste la premiere valeur
      } else if (_hero._life > LAST_LIFE) {
        eatByGhost();
      } else {
        _gameState = "END";
      }
    }
    if (_inky.conditionTouch()) {
      if (_hero._overpowered && _inky._frightened) {
        _inky = new Inky(_board, _hero);
        _hero._score += _ghostScore.remove(0);
      } else if (_hero._life > LAST_LIFE) {
        eatByGhost();
      } else {
        _gameState = "END";
      }
    }
    if (_pinky.conditionTouch()) {
      if (_hero._overpowered && _pinky._frightened) {
        _pinky = new Pinky(_board, _hero);
        _hero._score += _ghostScore.remove(0);
      } else if (_hero._life > LAST_LIFE) {
        eatByGhost();
      } else {
        _gameState = "END";
      }
    }
    if (_clyde.conditionTouch()) {
      if (_hero._overpowered && _clyde._frightened) {
        _clyde = new Clyde(_board, _hero);
        _hero._score += _ghostScore.remove(0);
      } else if (_hero._life > LAST_LIFE) {
        eatByGhost();
      } else {
        _gameState = "END";
      }
    }
    if (_fruit.conditionTouch() && _fruit._eatable){
      _hero._score += SCORE_BONUS; 
      _fruit._numberFruits -= 1; 
      _fruit._eatable = false; 
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

  void eatByGhost() { // quand pacman se fait toucher revient au depart avec une vie en moins
    _hero._life -= 1;
    _game = new Game(path.getAbsolutePath(), _board, _hero._life, _hero._score);
    _game._menu._time = millis();  // reset du temps
    _game._timeNoPause = millis();
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
  
  void drawMode(){
    textAlign(CENTER, CENTER);
    textSize(CELL_SIZE_X*0.8);
    fill(YELLOW); 
    text(_gameState, width/2, height*0.05);
  }

  void saveGame(BufferedWriter writer) { // fonction qui permet de sauvegarder mes données de jeu
    try {
      writer.write(String.format("\n_hero._position.x %f _position.y %f _direction.x %f _direction.y %f _overpowered %b _life %d _score %d _cacheLife %d _move %d _cacheMove %d _cellX %d _cellY %d", _hero._position.x, _hero._position.y, _hero._direction.x, _hero._direction.y, _hero._overpowered, _hero._life, _hero._score, _hero._cacheLifeUp, _hero._move, _hero._cacheMove, _hero._cellX, _hero._cellY));
      writer.write(String.format("\n_blinky._position.x %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d", _blinky._position.x, _blinky._position.y, _blinky._frightened, _blinky._move, _blinky._cacheMove, _blinky._direction.x, _blinky._direction.y, _blinky._directions.get(0), _blinky._directions.get(1), _blinky._cellX, _blinky._cellY)); // %f pour les floats, %d pour les entiers, %s pour les String et enfin %b pour les booléans
      writer.write(String.format("\n_inky._position.x %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d _passage %b", _inky._position.x, _inky._position.y, _inky._frightened, _inky._move, _inky._cacheMove, _inky._direction.x, _inky._direction.y, _inky._directions.get(0), _inky._directions.get(1), _inky._cellX, _inky._cellY, _inky._passage));
      writer.write(String.format("\n_pinky._position.x %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d _passage %b", _pinky._position.x, _pinky._position.y, _pinky._frightened, _pinky._move, _pinky._cacheMove, _pinky._direction.x, _pinky._direction.y, _pinky._directions.get(0), _pinky._directions.get(1), _pinky._cellX, _pinky._cellY, _pinky._passage));
      writer.write(String.format("\n_clyde._position.x %f _position.y %f _frightened %b _move %d _cacheMove %d _direction.x %f _direction.y %f _directions[0] %d _directions[1] %d _cellX %d _cellY %d _passage %b", _clyde._position.x, _clyde._position.y, _clyde._frightened, _pinky._move, _pinky._cacheMove, _clyde._direction.x, _clyde._direction.y, _clyde._directions.get(0), _clyde._directions.get(1), _clyde._cellX, _clyde._cellY, _clyde._passage));
      writer.write(String.format("\n_fruit._eatable %b _numberFruits %d", _fruit._eatable, _fruit._numberFruits));
      writer.write(String.format("\n_game._gameState %s _timeNoPause %f", _gameState, _game._timeNoPause));
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}
