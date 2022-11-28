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
      if(keyCode == LEFT){
        _hero.moveLeft();  
      }
      if(keyCode == RIGHT){
        _hero.moveRight();   
      }
      if(keyCode == UP){
        _hero.moveUp();   
      }
      if(keyCode == DOWN){
        _hero.moveDown();  
      }
    }
    
    else{
      if(key == 'q'){
        _hero.moveLeft();   
      }
      if(key == 'd'){
        _hero.moveRight();   
      }
      if(key == 'z'){
        _hero.moveUp();  
      }
      if(key == 's'){
        _hero.moveDown();  
      }
    }
  }
  
}
