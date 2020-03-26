/* Radar using ultrasonic sensor (Arduino code)
 * By Samaksh Sethi
 * 
 * Execution procedure:
 * 1. The distance from the ultrasonic sensor is measured
 * 2. The data is written to the serial monitor in the format: "angle,distance."
 * GitHub link - https://github.com/samakshsethi/radar
 */
 
#include <Servo.h>
  
const int trigPin = 10;     //Trigger pin of the ultrasonic sensor
const int echoPin = 11;     //Echo pin of the ultrasonic sensor
const int startAngle = 0;  //Starting angle of servo motor
const int endAngle = 180;   //Final angle of servo motor

long pulseTime;
int dist;

Servo myServo;    //Servo object for the servo motor

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
  myServo.attach(12);   //Servo motor attached to pin #12
}
void loop() {
  
  for(int i=startAngle;i<=endAngle;i++){  
  myServo.write(i);
  delay(30);
  dist=calculateDistance();
  Serial.print(i);      // Sends the angle to the serial port
  Serial.print(",");
  Serial.print(dist);   //Sends the distance to the serial port
  Serial.print(".");
  }
  
  for(int i=endAngle;i>startAngle;i--){  
  myServo.write(i);
  delay(30);
  dist=calculateDistance();
  Serial.print(i);       // Sends the angle to the serial port
  Serial.print(",");
  Serial.print(dist);    //Sends the distance to the serial port
  Serial.print(".");
  }
}

int calculateDistance(){    //Function for calculating the distance measured by the ultrasonic sensor
  
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);    // Sets the trigPin on HIGH state for 10 microseconds
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  pulseTime=pulseIn(echoPin, HIGH);    //Returns the sound wave travel time in microseconds
  dist=pulseTime*0.034/2;    //distance=time*speed, here time->time/2 because the echo travels on the same line twice
  return dist;
}
