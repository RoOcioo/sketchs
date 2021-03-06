int fps = 15;
float seconds = 12;
boolean export = true;

int frames = int(fps*seconds);
float time = 0;
int cycle = 0;

int seed = 2905337;

void setup() {
  size(640, 640, P3D);
  smooth(8);
  if (!export) pixelDensity(2);
  frameRate(fps);

  generate();
}

void draw() {
  if (export) {
    time = map((frameCount-1)%frames, 0, frames, 0, 1);
    cycle = int((frameCount-1)/frames);
  } else {
    time = map((millis()/1000.)%seconds, 0, seconds, 0, 1);
    cycle = int((millis()/1000.)/seconds);
  }

  render();

  if (export) {
    if (cycle > 0) exit();
    else saveFrame("export/f####.png");
  }
}

void render() {

  hint(DISABLE_DEPTH_TEST);

  background(0);

  translate(width*(0.5+cos(time*TAU*2)*0.05), height*(0.5+sin(time*TAU)*0.05));

  blendMode(ADD);

  int cc = 128;
  float da = TAU/cc;
  float r = width*0.23;
  noStroke();
  fill(255, 14);
  rectMode(ADD);
  for (int i = 0; i < cc; i++) {
    float a = da*(i+time)+PI*time;
    float s = 145*(pow(cos(time*TAU+da), 2)*0.25+0.75);
    pushMatrix();
    translate(cos(a)*r, sin(a)*r);
    rotateX(time*TAU+da*2);
    rotateY(time*TAU+PI+da*4);
    // rotateZ(time*PI*6);
    fill(getColor((time+i*(1.0/cc))*colors.length*2), 6);
    rect(0, 0, s, s);
    popMatrix();
  }
}

void keyPressed() {

  seed = int(random(9999999));
  generate();
}

void generate() {
  randomSeed(seed);
  noiseSeed(seed);
  println("seed:", seed);
}

int colors[] = {#DD1616, #72522A, #EDF4F9, #EA9FB6, #202DA3};
int rcol() {
  return colors[int(random(colors.length))];
}

int getColor() {
  return getColor(random(colors.length));
}

int getColor(float v) {
  v = abs(v); 
  v = v%(colors.length); 
  int c1 = colors[int(v%colors.length)]; 
  int c2 = colors[int((v+1)%colors.length)]; 
  return lerpColor(c1, c2, v%1);
} 