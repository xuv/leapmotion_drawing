import de.voidplus.leapmotion.*;

LeapMotion leap;

boolean init;
PVector oldPoint;
color bg = 125; // mid grey


void setup() {
  size(displayWidth, displayHeight);
  //size(800, 500);
  //size(300, 200);
  background(bg);
  // ...
  init = true;
  oldPoint = new PVector(0, 0, 0);
  strokeWeight(1);
  stroke(0);
  
  leap = new LeapMotion(this);
}

void draw() {
  // background(255);
  // ...
  int fps = leap.getFrameRate();
  // println( fps );


  // ========= HANDS =========
  
  if (leap.getHands().size() == 0) {
    //No hand
    init = true; // reset coordinates for the drawing
  }
  
  for (Hand hand : leap.getHands ()) {
    // ========= FINGERS =========
    for (Finger finger : hand.getFingers()) {
      // Alternatives:
      // hand.getOutstrechtedFingers();
      // hand.getOutstrechtedFingersByAngle();

      // ----- BASICS -----

      //int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      PVector finger_stabilized = finger.getStabilizedPosition();
      //PVector finger_velocity   = finger.getVelocity();
      //PVector finger_direction  = finger.getDirection();
      //float   finger_time       = finger.getTimeVisible();

      // ----- SPECIFIC FINGER -----

      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        if(init){
          oldPoint = finger_position;
          init = false;
        }
        //println("z: " + finger_stabilized.z + "y: " + finger_stabilized.y + "x: " + finger_stabilized.x);
        //println("z: " + finger_velocity.z + "y: " + finger_velocity.y + "x: " + finger_velocity.x);
        if ( finger_position.z > 45 ) {
          stroke(0);
        } else {
          stroke(255);
        }
        strokeWeight(abs(finger_position.z-oldPoint.z));
        line(oldPoint.x, oldPoint.y, finger_position.x, finger_position.y);
        oldPoint = finger_position;
        break;
      case 1:
        // System.out.println("index"); 
        break;
      case 2:
        // System.out.println("middle");
        break;
      case 3:
        // System.out.println("ring");
        break;
      case 4:
        // System.out.println("pinky");
        break;
      }
    }
  }
}

// ========= CALLBACKS =========

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

void keyPressed() {
  if (key == 'c') {
    // If it's not a letter key, clear the screen
    background(bg);
  }
}
