void mouseMoved(){
  angleDeg += (mouseX-pmouseX) * m_sens; 
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
  } else if (keyCode == 80) { // P
    coneAngle += 1;
  } else if (keyCode == 79) { // O
    coneAngle -= 1;
  }
}