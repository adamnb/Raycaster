int w = 1000, h = 500;

int gridw = 20, gridh = 10;
float blockw, blockh;
boolean blocks[][];


float px = 300, py = 300; // Player position
float spd = 5; // Walk speed
float m_sens = 1; // Mouse sensitivity

static final float RAY_LENGTH = 500; // MAXIMUM length of the ray 
float lengthSample = 5; // Distance finder precision

int rayCount = 1000; // Must be under window width
float coneAngle = 60, coneAngleRad;
float angleDeg = 40, angleRad;
float nearClipDefault = 6;
float nearClip = 30; // Near clipping plane

boolean run3d = true;
boolean draw3d = true;
boolean draw2d = false;
boolean drawGround = true;
color groundColor = color(127, 127, 0);

ArrayList distances = new ArrayList();

void settings () {
  size(w, h + 25);
}


void setup () {
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
  text("Disp. 3d: " + draw3d, 3, h+15);
  text("Disp. 2d: " + draw2d, 90, h+15);
  text("Run 3d: " + run3d, 180, h+15);
  text("Bearing: " + angleDeg + "°", 270, h+15);
  text("FOV: " + coneAngle + "°", 360, h+15);

  // Drawing map obstructions
  if (draw2d) {
    drawObstructions();
    draw2dGuides();
  }

  // Rendering IN 3D!!!
  // List all rays' distances
  if (run3d) {
    float g = abs((2*tan(coneAngle/2)*nearClip))/(rayCount-1);
    
    //for (float ang = angleRad - (coneAngleRad/2); ang <= angleRad + (coneAngleRad/2); ang += coneAngleRad / rayCount) {
    for (int i = 0; i < rayCount; i++) {
      float ang = angleRad - coneAngleRad/2 + (i+1)*(coneAngleRad / rayCount);
      //float ang = atan(tan(coneAngle/2)-(g*i));
      float r = raycast(px, py, ang);
      
      if (draw2d){
        drawRays(px, py, ang, r);
      }
       
      distances.add(r);
    }
    
    noStroke();
    if (drawGround && draw3d) {
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
      colHeight = constrain(colHeight, 0, h); // Prevents encroachment over debug bar
      if (draw3d)
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