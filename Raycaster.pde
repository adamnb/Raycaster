int w = 1000, h = 500; // Dimensions of play area

int gridw = 20, gridh = 10;
float blockw, blockh;
boolean blocks[][];


float px = 300, py = 300; // Player position
float spd = 5; // Walk speed
float m_sens = 1; // Mouse sensitivity

static final float RAY_LENGTH = 500; // MAXIMUM length of the ray 
float lengthSample = 5; // Distance finder precision

int rayCount = 500;
//int rayCount = 10001; // Must be under window width
int hRes = 1000;
float coneAngle = 60, coneAngleRad;
float angleDeg = 40, angleRad;
float clipDefault = 6;
float clip = 1; // Near clipping plane

boolean run3d = true;
boolean draw3d = true;
boolean draw2d = false;
boolean drawGround = true;
color groundColor = color(244, 110, 66);

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
  background(4, 54, 91);

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
    float g = abs((2*tan(coneAngle/2)*clip)/(rayCount-1));
    text("g: " + g, 430, h+15);

    for (int i = 0; i <= hRes; i++) { // Ray sweep loop
      // Calculate the angle at which the ray should be shot at
      float static_ang = atan(-clip*tan(coneAngleRad/2) + i * ((2*clip*tan(coneAngleRad/2))/(hRes-1))); 
      float ang = angleRad + static_ang; // Actual angle relative to player direction
     
      float clipping = sqrt(pow(clip*tan(static_ang), 2)+(pow(clip, 2)));
      float r = raycast(px, py, ang) - clipping; // Cast the ray

      if (draw2d) {drawRays(px, py, ang, r);}
       
      distances.add(r);
    }
    
    noStroke();
    if (drawGround && draw3d) {
      fill (groundColor);
      rect (0, h/2, w, h/2);
    }

    rectMode(CENTER);

    // Placing distances on screen
    for (int i = 0; i < distances.size(); i++) {
      float dist = (float)distances.get(i); // Retrieve distances from list
      float colHeight = (100/dist)*h;// Triangular Similarity
      
      if (dist == -1) // Override column height if ray doesn't touch anything
        colHeight = 0;
      
      float dist8 = 255*(dist/RAY_LENGTH); //  Distance out of 255
      float brightness = RAY_LENGTH - dist8;
      //fill (brightness, brightness, brightness, 255); // Brightness
      fill (255, 255, 255, 255);
      colHeight = constrain(colHeight, 0, h); // Prevents encroachment over debug bar
       
      if (draw3d)
        rect(((w/rayCount)/2)*i, h/2, w/rayCount, colHeight);
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

// other angle calculations
//float ang = angleRad - coneAngleRad/2 + (i+1)*(coneAngleRad / hRes); //Default;
//float ang = (angleRad-coneAngleRad/2) + (coneAngleRad/rayCount)*i;
