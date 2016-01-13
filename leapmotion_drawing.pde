import de.voidplus.leapmotion.*;

LeapMotion leap;

ArrayList<PVector> old;
boolean init;
PVector old_position, old_velocity, center, target;
color bg = 125; // mid grey

void setup() {
  //size(displayWidth, displayHeight);
  size(800, 500);
  //size(300, 300);
  background(bg);

  init = true;
  
  old = new ArrayList<PVector>();
  
  old_position = new PVector(0, 0, 0);
  old_velocity = new PVector(0, 0, 0);
  strokeWeight(1);
  stroke(0);

  center = new PVector(width/2, height, 50);
  target = new PVector();
  noFill();
  leap = new LeapMotion(this);
}

void draw() {
  int fps = leap.getFrameRate();

  // ========= HANDS =========

  if (leap.getHands().size() == 0) {
    //No hand
    init = true; // reset coordinates for the drawing
  }

  for (Hand hand : leap.getHands ()) {
    // ========= FINGERS =========
    for (Finger finger : hand.getFingers ()) {
      // Alternatives:
      // hand.getOutstrechtedFingers();
      // hand.getOutstrechtedFingersByAngle();

      // ----- BASICS -----

      //int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      //PVector finger_stabilized = finger.getStabilizedPosition();
      //PVector finger_velocity   = finger.getRawVelocity();
      //PVector finger_direction  = finger.getDirection();
      //float   finger_time       = finger.getTimeVisible();
      

      // ----- SPECIFIC FINGER -----

      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        break;
      case 1:
        // System.out.println("index");
       
       if (init) {
          old_position = finger_position;
          old.clear(); // Empties the ArrayList
          for(int i=0; i < 3; i++){
            old.add(old_position);          }
          init = false;
        }
        
        if ( finger_position.z > 45 ) {
          stroke(0);
        } else {
          stroke(255);
        }
        
        strokeWeight(abs(finger_position.z - old_position.z));
        
        
        curve (
          old.get(0).x, old.get(0).y,
          old.get(1).x, old.get(1).y,
          old.get(2).x, old.get(2).y,
          finger_position.x, finger_position.y
        );
         
        //line(finger_position.x, finger_position.y, finger_position.x + finger_velocity.x, finger_position.y-finger_velocity.y);
        
        // Store actual finger position for next round.
        old_position = finger_position;
        old.remove(0);
        old.add(old_position);   
         
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