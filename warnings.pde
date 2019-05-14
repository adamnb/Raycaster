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
  if (clip >= RAY_LENGTH) {
    println ("The near clipping plane is greater than the ray length limit. This value will be corrected to the default, " + clipDefault + ".");
    clip = clipDefault;
  }
}

void coneAngleWarning(){
  if (coneAngle >= 180){
    println("The FOV cone angle is greater than 180°. This value will be corrected to 60");
    coneAngle = 60;
  }
}
