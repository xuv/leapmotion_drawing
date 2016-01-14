import processing.pdf.*;
import de.voidplus.leapmotion.*;

LeapMotion leap;
PGraphics pdf;
ArrayList<PVector> history;
PVector initHistory = new PVector(0,0,0);

PVector[] old;
boolean init;
PVector old_position, old_velocity, center, target;
color bg = 125; // mid grey

// Resets the storage of previous positions to a "current" value
void resetOld(PVector[] old,  PVector current ){
  old[0] = current;
  old[1] = current;
  old[2] = current;
}

// Moves the storage of previous positions to a new step
void stepOld(PVector[] old, PVector current){
  old[0] = old[1];
  old[1] = old[2];
  old[2] = current;
}

String str_(int s){
  if (s < 10) {
    return "0" + str(s);
  } else {
    return str(s);
  }
}

void exportPDF(){
  String filename =  str_(year()) + str_(month()) + str_(day()) + "-" + str_(hour()) + str_(minute()) + str_(second()) + ".pdf" ;
  pdf = createGraphics( displayWidth, displayHeight, PDF, filename);
  PVector[] pdfOld = new PVector[3];
  if ( history.size() > 3 ){
    
    pdf.beginDraw();
    pdf.background(128);
    pdf.noFill();
    
    for (int i=0; i< history.size(); i++){
      PVector current = history.get(i);
      
      if ( current.x == initHistory.x && current.y == initHistory.y && current.z == initHistory.z){
        // Similar as the init reset that happens during drawing
        if (i+1 < history.size()){
          resetOld(pdfOld, history.get(i+1));
        }
      } else {
      
        if ( current.z > 45 ) {
          pdf.stroke(0);
        } else {
          pdf.stroke(255);
        }
        pdf.strokeWeight(abs(current.z - pdfOld[2].z));
        pdf.curve (
          pdfOld[0].x, pdfOld[0].y,
          pdfOld[1].x, pdfOld[1].y,
          pdfOld[2].x, pdfOld[2].y,
          current.x, current.y
        );
        stepOld(pdfOld, current);
      
      }
    }
    pdf.dispose();
    pdf.endDraw();
  } else {
    println("Not enough points in history to save a PDF");
  }
}

void setup() {

  size(displayWidth, displayHeight);
  
  background(bg);

  init = true;
  
  old = new PVector[3];
  history = new ArrayList<PVector>();
  
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

      PVector finger_position   = finger.getPosition();

      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        break;
      case 1:
        // System.out.println("index"); 
       if (init) {
          history.add(initHistory);
          old_position = finger_position;
          resetOld( old,  old_position ); // Empties the ArrayList
          init = false;
        }
        
        if ( finger_position.z > 45 ) {
          stroke(0);
        } else {
          stroke(255);
        }
        
        strokeWeight(abs(finger_position.z - old_position.z));
        
        
        curve (
          old[0].x, old[0].y,
          old[1].x, old[1].y,
          old[2].x, old[2].y,
          finger_position.x, finger_position.y
        );
         
        //line(finger_position.x, finger_position.y, finger_position.x + finger_velocity.x, finger_position.y-finger_velocity.y);
        
        // Store actual finger position for next round.
        old_position = finger_position;
        history.add(finger_position);
        stepOld(old, old_position);   
         
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
    exportPDF();
    history.clear();
    init= true;
    background(bg);
  }
}