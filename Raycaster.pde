int w = 1000, h = 500;

int gridw = 20, gridh = 10;
float blockw, blockh;
boolean blocks[][];


float px = 300, py = 300; // Player position
float spd = 5; // Walk speed
float m_sens = 1; // Mouse sensitivity

static final float RAY_LENGTH = 500; // MAXIMUM length of the ray 
float lengthSample = 5; // Distance finder precision

int rayCount = 1001; // Must be under window width
float coneAngle = 60, coneAngleRad;
float angleDeg = 40, angleRad;
float nearClipDefault = 6;
float nearClip = 600; // Near clipping plane


boolean draw3d = true;
boolean draw2d = false;
boolean drawGround = true;
color groundColor = color(127, 127, 0);

ArrayList distances = new ArrayList();

void settings () {
  size(w, h + 25);
}


void setup () {
  //rWin = new renderer();
  rayCountWarning();
  nearClipWarning();
  coneAngleWarning();

  blockw = w/gridw;
  blockh = h/gridh;
  blocks = new boolean [gridh][gridw];

  for (int y = 0; y < blocks.length; y++) {
    for (int x = 0; x < blocks[y].length; x++) {
      float r = random(-200, 200);
      boolean member = false;

      if (r > 100) {
        member = true; /*println("Member");*/
      } else {
        member = false; /*println ("Not a member");*/
      }

      blocks[y][x] = member;
    }
  }
}


void mouseMoved(){
  angleDeg += (mouseX-pmouseX) * m_sens; 
}


void draw () {
  
  // Angle loop around
  if (angleDeg > 360){
    angleDeg = angleDeg - 360;
  }
  
  if (angleDeg < 0){
    angleDeg = 360 + angleDeg;
  }

  angleRad = radians(angleDeg);
  coneAngleRad = radians(coneAngle);

  rectMode(CORNER);
  background(0);

  // Debug bar
  fill (255);
  text("3d: " + draw3d, 3, h+13);
  text("2d: " + draw2d, 60, h+13);
  text("Bearing: " + angleDeg + "°", 117, h+13);

  // Drawing map obstructions
  if (draw2d) {
    drawObstructions();
    draw2dGuides();
  }

  // Rendering IN 3D!!!
  // List all rays' distances
  if (draw3d) {
    //for (int rayN = 0; rayN < rayCount; rayN ++){
    for (float ang = angleRad - (coneAngleRad/2); ang <= angleRad + (coneAngleRad/2); ang += coneAngleRad / rayCount) {

      distances.add(raycast(px, py, ang));
    }
    
    noStroke();
    if (drawGround) {
      fill (groundColor);
      rect (0, h/2, w, h/2);
    }

    rectMode(CENTER);

    // Place distances on screen
    float rectWidth = w/distances.size();

    for (int i = 0; i < distances.size(); i++) {

      float dist = (float)distances.get(i); 
      float colHeight = 10000000/(PI * pow(dist, 2)); // Inverse square 
      
      if (dist == -1){ // Override column height if ray doesn't touch anything
        colHeight = 0;
      }

      fill (colHeight); // Brightness
      rect((i*w)/(distances.size()-1), h/2, 2, colHeight);
      
    }

    distances.clear();
  }
}


// Casting the rays 
float raycast (float ox, float oy, float angle) {
  float y = oy, x = ox; // Set start position to ray origin

  for (int i = 0; i < RAY_LENGTH; i++) { // Iterate along the ray
    x += cos(angle) * lengthSample; 
    y += sin(angle) * lengthSample;

    // Local positions relative to ray origin
    float a = x-px; 
    float o = y-py;  
    float h = sqrt((a*a) + (o*o)); // Ray hit distance

    stroke (255, 0, 0);
    strokeWeight (3);

    for (int iy = 0; iy < blocks.length; iy++) {
      for (int ix = 0; ix < blocks[iy].length; ix++) {
        if (blocks[iy][ix]) {
          if (x > ix*blockw && x < ix*blockw + blockw && y > iy*blockh && y < iy*blockh + blockh) {
            return h;
          }
        }
      }
    }
  }  
  return -1; // Ray hit nothing
}


void drawObstructions (){
  strokeWeight(1);
  fill(0, 127, 0);
  for (int by = 0; by < blocks.length; by ++) {
    for (int bx = 0; bx < blocks[by].length; bx ++) {
      if (blocks[by][bx]) {
        rect (bx*blockw, by*blockh, blockw, blockh);
      }
    }
  }
}

void draw2dGuides () {
  noFill();
  stroke(255, 0, 0);
  strokeWeight(1);
  line(px, py, px + (cos(angleRad - (coneAngleRad/2)) * RAY_LENGTH), py + (sin(angleRad - (coneAngleRad/2)) * RAY_LENGTH)); // Left FOV line
  line(px, py, px + (cos(angleRad + (coneAngleRad/2)) * RAY_LENGTH), py + (sin(angleRad + (coneAngleRad/2)) * RAY_LENGTH)); // Right FOV line
  line(px, py, px + cos(angleRad) * RAY_LENGTH, py + sin(angleRad) * RAY_LENGTH); // Center line
  ellipse (px, py, RAY_LENGTH*2, RAY_LENGTH*2); // Ray limit
  ellipse (px, py, nearClip*2, nearClip*2); // Near clipping circle (clipping plane tangent to this)

  // Origin Point
  stroke(0, 255, 0);
  strokeWeight(5); 
  point(px, py);

  text("(" + px + ", " + py + ")", px + 6, py + 6);
}

void keyPressed() {
  if (keyCode == 37) { // strafe left
    py += sin((angleRad)-PI/2) * spd;
    px += cos((angleRad)-PI/2) * spd;
  } else if (keyCode == 39) { // strafe right
    py += sin((angleRad)+PI/2) * spd;
    px += cos((angleRad)+PI/2) * spd;
  } else if (keyCode == 38) { // forward
    px += cos(angleRad) * spd;
    py += sin(angleRad) * spd;
  } else if (keyCode == 40) { // backward
    px -= cos(angleRad) * spd;
    py -= sin(angleRad) * spd;
  } else if (keyCode == 81) { // Q: Turn left 
    angleDeg -= 1;
  } else if (keyCode == 69) { // E: Turn right
    angleDeg += 1;
  } else if (keyCode == 50) { // 2
    draw2d = !draw2d;
    println ("Toggled 2d display: " + draw2d);
    blankWarning();
  } else if (keyCode == 51) { // 3
    draw3d = !draw3d;
    println ("Toggled 3d display: " + draw3d);
    blankWarning();
  } else if (keyCode == 71) { // G
    drawGround = !drawGround;
    println ("Toggled ground: " + drawGround);
  }
}


// WARNING MESSAGES
void blankWarning () {
  if  (draw2d == false && draw3d == false) {
    println ("Both 2d and 3d display are off. This should display nothing.");
  }
}

void rayCountWarning () {
  if (rayCount > width) {
    println ("The ray count you chose is greater than the screen width. This value will be corrected to " + width + "." );
    rayCount = width;
  }
}

void nearClipWarning() {
  if (nearClip >= RAY_LENGTH) {
    println ("The near clipping plane is greater than the ray length limit. This value will be corrected to the default, " + nearClipDefault + ".");
    nearClip = nearClipDefault;
  }
}

void coneAngleWarning(){
  if (coneAngle >= 180){
    println("The FOV cone angle is greater than 180°. This value will be corrected to 60");
    coneAngle = 60;
  }
}
