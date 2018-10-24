int distance = 0;

void setup() {
    pinMode(2, INPUT);
    Serial.begin(9600);
    attachInterrupt(digitalPinToInterrupt(2), read, RISING);
}

void loop() {
  
}

void read() {
  distance += 1;
  
  Serial.print(millis());
  Serial.print(" ");
  Serial.print(distance);
    if (distance % 30 == 0) {
      Serial.print("-");
    }
  Serial.println();
}

