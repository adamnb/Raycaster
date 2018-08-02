class renderer extends PApplet {
  renderer() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  int w, h;
  
  Raycaster mWin;
  
  
  void settings () {
    mWin = new Raycaster();
    size (1100, 500);
    w = width;
    h = height;
  }
  
  public ArrayList thisdistances;
  boolean ready;
  
  
  void draw () {
    background (0,0, 64);
    textSize(20);
    text("This is the renderer window", 0, 18);
    
    rectMode(CENTER);
    noStroke();
    
    if (ready){
      if (thisdistances.size() != 0){
        float rectWidth = w/thisdistances.size();
        for (int i = 0; i < thisdistances.size(); i++){
          
          float dist = (float)thisdistances.get(i);
          float colHeight = RAY_LENGTH - dist;
          
          if (colHeight < 0){
            colHeight = 0;
          }
          
          fill (255-0.51*dist);
          rect(i*rectWidth + rectWidth/2, h/2, rectWidth, colHeight);
          //println (colHeight);
        }
      }
      else {
        println("Something is wrong and the distances array is 0");
      }
      thisdistances.clear();
      ready = false; 
    }
    
   }
    
  public void render(ArrayList dists) {    
    thisdistances = dists;
    ready = true;
  }
}
