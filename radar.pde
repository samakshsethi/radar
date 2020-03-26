/* Radar using ultrasonic sensor (Processing code, UI)
 * By Samaksh Sethi
 * 
 * Execution procedure:
 * 1. The connection is established to serial port
 * 2. Radar outline is drawn, then the lines are drawn followed by the text
 * 3. The entire radar UI is covered with a recatangle of 4% opacity to give an effect of fading
 *
 * GitHub link - https://github.com/samakshsethi/radar
 */
 
import processing.serial.*;     //Library for serial communication
import java.awt.event.KeyEvent; //Library for reading the data from the serial port
import java.io.IOException;     //Library for handling exceptions

Serial myPort; // defines object of Serial type
String data="";
String angle="";
String distance="";
float pixels;
int iAngle, iDistance;
int index1=0;

void setup() {
 size (1920, 1080);                        //Processing box size, change to screen resolution
 background(0);
 smooth();                                 //Enables Anti-Aliasing
 myPort = new Serial(this,"COM6", 9600);   //Change to the arduino connected port number
 myPort.bufferUntil('.');                  //Reads the data from the serial port up to '.'. So it reads: "angle,distance."
}

void draw() {  
  fill(100,250,30); //Slightly dark green color
  drawRadar(); 
  drawLine();
  drawText();
  
  //This simulates fading of the line
  noStroke();
  fill(0,4);
  rect(0, 0, width, height); 
}

void serialEvent (Serial myPort) {                   //Starts reading data from the serial port
  //Reads the data from the serial port up to '.' and stores it in "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);          //Removes '.'
  
  index1 = data.indexOf(",");                        //Finds index of ','
  angle= data.substring(0, index1);                  //Reads the data from position 0 to index1 ie angle
  distance= data.substring(index1+1, data.length()); //Reads the data from position index1+1 to end ie distance
  
  //Converts the String variables into integer for calculations
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() {    //Draws the basic outline for the radar UI
  pushMatrix();
  translate(width/2,height*0.9);   //Moves the origin to new coordinates
  noFill();
  strokeWeight(2);
  stroke(50,200,30);
  
  //Arc lines
  arc(0,0,width*0.8,width*0.8,PI,TWO_PI);
  arc(0,0,width*0.6,width*0.6,PI,TWO_PI);
  arc(0,0,width*0.4,width*0.4,PI,TWO_PI);
  arc(0,0,width*0.2,width*0.2,PI,TWO_PI);

  //Angled lines
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  
  popMatrix();
}

void drawLine() {    //Draws line for each angle scanned
  pushMatrix();
  translate(width/2,height*0.9);
  strokeWeight(5);
  stroke(100,250,80); //Green colour
  line(0,0,width*0.9*cos(radians(iAngle))/2,-width*0.9*sin(radians(iAngle))/2); //Draws line according to iAngle
  strokeWeight(6);
  stroke(255,30,30); //Red color
  pixels = iDistance*((height-height*0.1666)*0.025); //Conversion from cm to pixels
  
  if(iDistance<40){    //Prints only for distance less than 40cm otherwise lnes will always be red at the end
  line(pixels*cos(radians(iAngle)),-pixels*sin(radians(iAngle)),width*0.9*cos(radians(iAngle))/2,-width*0.9*sin(radians(iAngle))/2);
  }
  popMatrix();
}

void drawText() { // draws the texts on the screen
  
  pushMatrix();
  noStroke();
  fill(0);
  rect(0, height*0.9, width, height); 
  fill(50,200,30);
  textSize(40);
  if(iDistance<40) {
    text("Distance: "+iDistance+" cm"+"    Angle: " + iAngle +" °" , 100, height*0.95);
  }else{
    text("Distance: Not in range"+"    Angle: " + iAngle +" °" , 100, height*0.95);
  }
  popMatrix(); 
}
