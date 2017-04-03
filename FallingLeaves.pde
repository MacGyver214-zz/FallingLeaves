Leaf leaf1, leaf2;
ArrayList<Leaf> colorLeaves = new ArrayList<Leaf>();
ArrayList<Leaf> darkLeaves = new ArrayList<Leaf>();
int max = 60;
PImage background;

void setup() {
  fullScreen(P3D);
  background = loadImage("forestry.jpg");
  background.resize(width,height);
  background(background);
  pointLight(255,255,255,0,0,20);
  
  for (int i = 0; i < max; i++) {
    float newX = random(width);
    float newY = random(-500,-200);
    float newZ = random(-500,100);
    colorLeaves.add(new Leaf(newX,newY,newZ, true));
  }
  
  for (int i = 0; i < max; i++) {
    float newX = random(width);
    float newY = random(-500,-400);
    float newZ = random(-800,-500);
    darkLeaves.add(new Leaf(newX,newY,newZ, false));
  }
}

void draw() {
  background(background);
  lights();
  pointLight(100,100,100,0,0,100);

  for (int i = 0; i < colorLeaves.size(); i++) {
    colorLeaves.get(i).display();
    if (colorLeaves.get(i).checkOffScreen()) {
      colorLeaves.remove(i);
      colorLeaves.add(new Leaf(random(width),-200,random(-300,300),true));
    }
    colorLeaves.get(i).drift();
  }
  for (int i = 0; i < darkLeaves.size(); i++) {
    darkLeaves.get(i).display();
    if (darkLeaves.get(i).checkOffScreen()) {
      darkLeaves.remove(i);
      darkLeaves.add(new Leaf(random(width),-500,random(-500,-300),false));
    }
    darkLeaves.get(i).drift();
  }
}

class Leaf {
  float[] leafCenter = new float[3];
  float[] initPlacement = {-100,0,0,100,0,0};
  PShape leaf;
  float angle = 0;
  float dropRate = random(1,4);
  float dropRateX = random(-3,3);
  float randX, randY, randZ, randDX, randDY, randDZ, randR, randG, randB;
  boolean colorOn;
  private int anchor1XY = 100;
  private int anchorZ = 40;
  private int anchor2X = 20;
  private int anchor2Y = 50;

  // Constructor
  Leaf(float xpos, float ypos, float zpos, boolean colorOn) {
    leafCenter[0] = xpos;
    leafCenter[1] = ypos;
    leafCenter[2] = zpos;
    
    this.colorOn = colorOn;
    
    leaf = createShape();
    leaf.beginShape();
    if (colorOn) {
      leaf.fill(noise(frameCount*0,003,randR),noise(frameCount*0.003,randG),noise(frameCount*0.003,randB));
    } else {
      leaf.fill(0);
    }
    
    leaf.vertex(initPlacement[0],initPlacement[1],initPlacement[2]);
    leaf.bezierVertex(initPlacement[0]+anchor1XY,initPlacement[1]-anchor1XY,initPlacement[2]+anchorZ,
                 initPlacement[3]-anchor2X,initPlacement[4]+anchor2Y,initPlacement[5]+anchorZ,
                 initPlacement[3],initPlacement[4],initPlacement[5]);
    leaf.vertex(initPlacement[3],initPlacement[4],initPlacement[5]);
    leaf.bezierVertex(initPlacement[3]-anchor1XY,initPlacement[4]+anchor1XY,initPlacement[5]-anchorZ,
                 initPlacement[0]+anchor2X,initPlacement[1]+anchor2X,initPlacement[2]-anchorZ,
                 initPlacement[0],initPlacement[1],initPlacement[2]);
    leaf.endShape(CLOSE);
    
    randX = random(5000);
    randY = random(5000);
    randZ = random(5000);
    randDX = random(5000);
    randDY = random(5000);
    randDZ = random(5000);
    randR = random(5000);
    randG = random(5000);
    randB = random(5000);
  }
  
  void drift() {
    float dy = noise(frameCount*0.022, randDY)*dropRate;
    float dx = noise(frameCount*0.223, randDX)*dropRateX;
    float dz = noise(frameCount*0.215, randDZ)*2-1;
    leafCenter[0] += dx;
    leafCenter[1] += dy;
    leafCenter[2] += dz;
  }

  void display() {
    float theta = radians(frameCount);
    float xAxis = noise(frameCount*0.002,randX)*2-1;
    float yAxis = noise(frameCount*0.002,randY)*2-1;
    float zAxis = noise(frameCount*0.002,randZ)*2-1;
    
    pushMatrix();
    if (colorOn) {
      leaf.setFill(color(noise(frameCount*0,013,randR)*255-50,noise(frameCount*0.023,randG)*255-50,noise(frameCount*0.033,randB)*255-50));
    } else {
      leaf.setFill(color(0));
    }
    translate(leafCenter[0], leafCenter[1], leafCenter[2]);
    rotate(theta,xAxis,yAxis,zAxis);
    shape(leaf);
    popMatrix();
  }
  
  boolean checkOffScreen() {
    if (colorOn) {
      return leafCenter[1] > height + 300;
    } else {
        return leafCenter[1] > height + 500;
    }
  }
}