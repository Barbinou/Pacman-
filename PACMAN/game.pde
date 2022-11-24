class Game 
{
  Board _board;
  Hero _hero;
  
  String _levelName;
  
  Game() {
    _board = new Board();
    _hero = new Hero();
  }
  
  void update() {
  }
  
  void drawIt() {
    _board.drawIt(); 
  }
  
  void handleKey(int key) {
    if (key == CODED) {
      if(keyCode == LEFT){
        println("gauche");  
      }
      if(keyCode == RIGHT){
        println("droite"); 
      }
      if(keyCode == UP){
        println("haut"); 
      }
      if(keyCode == DOWN){
        println("bas"); 
      }
    }
    
    else{
      if(key == 'q'){
        println("gauche"); 
      }
      if(key == 'd'){
        println("droite"); 
      }
      if(key == 'z'){
        println("haut"); 
      }
      if(key == 's'){
        println("bas"); 
      }
    }
  }
  
}
