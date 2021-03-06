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
  ellipse (px, py, clip*2, clip*2); // Near clipping circle (clipping plane tangent to this)

  // Origin Point
  stroke(0, 255, 0);
  strokeWeight(5); 
  point(px, py);

  text("(" + px + ", " + py + ")", px + 6, py + 6);
}

void drawRays(float x, float y, float t, float h) { 
  stroke(127, 0, 255);
  strokeWeight(2);
  line(x, y, x + (cos(t)*h), y + (sin(t)*h));
}
