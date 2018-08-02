renderer rWin;

int w, h;

float sw = 200, sh = 200; // Dimensions of the square obstruction
int gridw = 10, gridh = 10;
float blockw, blockh;
boolean blocks[][];


float px = 300, py = 300; // Player position
float spd = 5; // Walk speed
float m_sens = 0.5; // Mouse sensitivity

static final float RAY_LENGTH = 500; // MAXIMUM length of the ray 
float lengthSample = 5; // Distance finder precision

int rayCount = 1099; // Must be under window width
float coneAngle = 120, coneAngleRad;
float angleDeg = 40, angleRad;

boolean renderReady = false;
ArrayList distances = new ArrayList();

void settings () {
  size(1100, 500);
}

void setup () {
  rWin = new renderer();
  
  w = width; h = height;
  
  blockw = w/gridw;
  blockh = h/gridh;
  blocks = new boolean [gridh][gridw];
  
  for (int y = 0; y < blocks.length; y++){
    for (int x = 0; x < blocks[y].length; x++){
      float r = random(-200, 200);
      boolean member = false;
      
      if (r > 100){member = true; println("Member");}
      else{member = false; println ("Not a member");}
      
      blocks[y][x] = member;
    }
  }
}

void draw () {
  angleDeg += (mouseX-pmouseX) * m_sens;
  
  angleRad = radians(angleDeg);
  coneAngleRad = radians(coneAngle);

  rectMode(CORNER);
  background(0);
  noStroke();
  
  // Drawing obstructions
  strokeWeight(1);
  noFill();
  for (int by = 0; by < blocks.length; by ++){
    for (int bx = 0; bx < blocks[by].length; bx ++){
      if (blocks[by][bx]){
        rect (bx*blockw, by*blockh, blockw, blockh);
      }
    }
  }

  // Draw FOV
  stroke(255, 0, 0);
  strokeWeight(1);
  line(px, py, px + (cos(angleRad) * RAY_LENGTH), py + (sin(angleRad) * RAY_LENGTH)); // Left FOV line
  line(px, py, px + (cos(angleRad + coneAngleRad) * RAY_LENGTH), py + (sin(angleRad + coneAngleRad) * RAY_LENGTH)); // Right FOV line

  // Origin Point
  stroke(0, 255, 0);
  strokeWeight(5);
  point(px, py);

  text("(" + px + ", " + py + ")", px + 6, py + 6);
    
  // Rendering IN 3D!!!
  // List all rays' distances
  for (float ang = angleRad; ang < angleRad + coneAngleRad; ang += coneAngleRad / rayCount){
    distances.add(raycast(px, py, ang));
  }
  //renderReady = true;
  //println (distances);
  
  rectMode(CENTER);
  noStroke();
  
  // Place distances on screen
  float rectWidth = w/distances.size();
  for (int i = 0; i < distances.size(); i++){
    
    float dist = (float)distances.get(i);
    //float colHeight = RAY_LENGTH - dist; // Linear (BAD)
    float colHeight = 10000000/(PI * (dist*dist)); // Inverse square (NOT AS BAD)
    
    if (colHeight < 0){
      colHeight = 0;
    }
    
    fill (255-0.51*dist);
    rect(i*rectWidth + rectWidth/2, h/2, rectWidth, colHeight);
    //println (colHeight);
  }
  
  //rWin.render(distances);
  //rWin.ready = true;
  //rWin.thisdistances = distances;
    
  distances.clear();
}

float raycast (float ox, float oy, float angle){
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
    //point(x, y);

    
    for (int iy = 0; iy < blocks.length; iy++){
      for (int ix = 0; ix < blocks[iy].length; ix++){
        if (blocks[iy][ix]){
          if (x > ix*blockw && x < ix*blockw + blockw && y > iy*blockh && y < iy*blockh + blockh){
            return h;
          }
        }
      }
    }

  }  
  return RAY_LENGTH;
}


void keyPressed() {
  if (keyCode == 37) { // strafe left
    py += sin((angleRad + (coneAngleRad/2))-PI/2) * spd;
    px += cos((angleRad + (coneAngleRad/2))-PI/2) * spd; 
  } else if (keyCode == 39) { // strafe right
    py += sin((angleRad + (coneAngleRad/2))+PI/2) * spd;
    px += cos((angleRad + (coneAngleRad/2))+PI/2) * spd; 
  } else if (keyCode == 38) { // forward
    px += cos(angleRad + (coneAngleRad/2)) * spd;
    py += sin(angleRad + (coneAngleRad/2)) * spd;
  } else if (keyCode == 40) { // backward
    px -= cos(angleRad + (coneAngleRad/2)) * spd;
    py -= sin(angleRad + (coneAngleRad/2)) * spd;
  }
}
