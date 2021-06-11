import processing.core.PApplet;
import processing.core.PGraphics;
import java.text.*;

import java.util.Random;


public class Room3D extends PApplet{

        public static void main(String[] args) {
            PApplet.runSketch(new String[]{"Room3D"}, new Room3D());
        }

    final int BLACK = color(0, 0, 0);
    final int PURPLE = color(158, 23, 179);
    final int YELLOW = color(255, 255, 0);
    final int GREEN = color(161, 235, 52);
    final int BLUE = color(0, 119, 255);
    final int RED = color(255, 0, 0);
    final int ORANGE = color(255, 106, 0);
    final int BRIGHT_BLUE = color(0, 221, 255);
    final int WHITE = color(255, 255, 255);
    final int GRAY = color(50);

    //setup
    Random r = new Random();
    int WINDOW_SIZE_X;      //horizontal window size
    int WINDOW_SIZE_Y;      //vertical window size
    int frameDelay = 10;
    int repeatStep = frameDelay;
    int firstSpeed = 3;
    int trueSpeed = firstSpeed;
    int speed = firstSpeed;                  //block's falling speed
    int timeTillLevelUp = 2000;
    int levelCount = timeTillLevelUp;
    int level = 1;
    int countFall = 100;            //countdown before moving 1 field down
    int fall = countFall;
    int points = 0;
    int maxLevel = 10;
    boolean gameOver = false;
    int[][] grid = new int[20][10];
    float blockWidth = 0;
    float anchorX;
    float anchorY;
    float lengthUnit;               //1000 lengthUnits equal displayHeight, needed for compatibility with different screen sizes
    float room_x;
    float room_y;
    float room_z;
    float viewerDistance;
    Point viewCenter;
    Cube rotTest;
    Cube room;
    Cube house;
    Cube house2;
    Point roofTop;
    Line roofTop2;

    boolean keyUp = false;
    boolean keyDown = false;
    boolean keyLeft = false;
    boolean keyRight = false;
    boolean keyEsc = false;
    boolean keySpace = false;
    boolean keyR = false;

    public void keyPressed() {
        if (keyCode == ESC) keyEsc = true;
        if (keyCode == UP) keyUp = true;
        if (keyCode == DOWN) keyDown = true;
        if (keyCode == LEFT) keyLeft = true;
        if (keyCode == RIGHT) keyRight = true;
        if (key == ' ') keySpace = true;
        if (key == 'r') keyR = true;
    }

    public void keyReleased() {
        if (keyCode == UP) keyUp = false;
        if (keyCode == DOWN) keyDown = false;
        if (keyCode == LEFT) keyLeft = false;
        if (keyCode == RIGHT) keyRight = false;
        if (key == ' ') keySpace = false;
        if (key == 'r') keyR = true;
    }

    public void settings() {
        WINDOW_SIZE_X = displayWidth;
        WINDOW_SIZE_Y = displayHeight;
        fullScreen();
//        size(WINDOW_SIZE_X, WINDOW_SIZE_Y);
    }

    public void setup() {
        background(BLACK);
        lengthUnit = displayHeight / 1000f;
        room_x = lengthUnit * 800f;
        room_y = lengthUnit * 500f;
        room_z = lengthUnit * 500f;
        viewerDistance = lengthUnit * 2000f;
        anchorX = displayWidth/2f - room_x/2f;
        anchorY = displayHeight/2f - room_y/2f;
        rotTest = new Cube(new Point(-100, -100, 0), 100, 100, 100);
        room = new Cube(new Point(0 - room_x/2, - room_y/2 + lengthUnit*300, -lengthUnit*400), room_x, room_y, room_z + lengthUnit*400);
        house = new Cube(new Point( - room_x*3/8, room.pos.y - room_y/2, room_z/4), room_x/2, room_y/2, room_z/2);
        house2 = new Cube(new Point(house.getA2().x, house.getA2().y - room_y/2, house.getA2().z), room_x/4, room_y, room_z/2);
        roofTop = new Point(house2.pos.x + house2.width/2, house2.pos.y - house2.height/2, house2.pos.z + house2.depth/2);
        roofTop2 = new Line(new Point(house.pos.x, house.pos.y - house.height/2, roofTop.z), new Point(house.pos.x + house.width, house.pos.y - house.height/2, roofTop.z));

        viewCenter = new Point(0, 0, 0);
    }

    void keyAction() {
        if (keyEsc) exit();
        if (keyUp) viewCenter.y -= 10f;
        if (keyDown) viewCenter.y += 10f;
        if (keyLeft) viewCenter.x -= 10f;
        if (keyRight) viewCenter.x += 10f;
    }

    class Point {
        float x;
        float y;
        float z;
        Point(float x, float y, float z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        Point(float x, float y) {
            this.x = x;
            this.y = y;
            this.z = 0;
        }
        public String toString() {
            return "(" + x/lengthUnit + ", " + y/lengthUnit + ", " + z/lengthUnit + ")";
        }
    }
    class Line {
        Point p1;
        Point p2;
        Line(Point p1, Point p2) {
            this.p1 = new Point(p1.x, p1.y, p1.z);
            this.p2 = new Point(p2.x, p2.y, p2.z);
        }
        void draw() {
            drawLine(p1, p2);
        }
    }
    class Cube {
        Point pos;
        float width;
        float height;
        float depth;

        Cube(Point pos, float width, float height, float depth) {
            this.pos = pos;
            this.width = width;
            this.height = height;
            this.depth = depth;
        }

        Point getA1() {
            return new Point(pos.x, pos.y, pos.z);
        }

        Point getA2() {
            return new Point(pos.x + width, pos.y, pos.z);
        }

        Point getA3() {
            return new Point(pos.x + width, pos.y, pos.z + depth);
        }

        Point getA4() {
            return new Point(pos.x, pos.y, pos.z + depth);
        }

        Point getB1() {
            return new Point(pos.x, pos.y + height, pos.z);
        }

        Point getB2() {
            return new Point(pos.x + width, pos.y + height, pos.z);
        }

        Point getB3() {
            return new Point(pos.x + width, pos.y + height, pos.z + depth);
        }

        Point getB4() {
            return new Point(pos.x, pos.y + height, pos.z + depth);
        }

        void draw() {
//            rect(pos.x + (width - (width/(viewerDistance+depth)*viewerDistance))/2, pos.y + (height - (height/(viewerDistance+depth)*viewerDistance))/2, width/(viewerDistance+depth)*viewerDistance, height/(viewerDistance+depth)*viewerDistance);
//            rect(pos.x, pos.y, width, height);
            drawRect(this.getA4(), this.width, this.height);
            drawLine(getA1(), getA4());
            drawLine(getA2(), getA3());
            drawLine(getB1(), getB4());
            drawLine(getB2(), getB3());
            drawRect(this.pos, this.width, this.height);
        }

        public String toString() {
            return "\npos: " + pos + "\nwidth: " + width/lengthUnit + "\nheight: " + height/lengthUnit + "\ndepth: " + depth/lengthUnit;
        }
    }

    void drawRect(Point pos, float width, float height) {
        rect( displayWidth/2 - (viewCenter.x - pos.x)/(viewerDistance+pos.z)*viewerDistance, displayHeight/2 - (viewCenter.y - pos.y)/(viewerDistance+pos.z)*viewerDistance,
                width/(viewerDistance+pos.z)*viewerDistance, height/(viewerDistance+pos.z)*viewerDistance);
    }
    void drawLine(Point pos1, Point pos2) {
        line(displayWidth/2 - (viewCenter.x - pos1.x)/(viewerDistance+pos1.z)*viewerDistance, displayHeight/2 - (viewCenter.y - pos1.y)/(viewerDistance+pos1.z)*viewerDistance,
                displayWidth/2 - (viewCenter.x - pos2.x)/(viewerDistance+pos2.z)*viewerDistance, displayHeight/2 - (viewCenter.y - pos2.y)/(viewerDistance+pos2.z)*viewerDistance );
    }
    void drawEllipse(Point pos, float r) {
        ellipse(displayWidth/2 - (viewCenter.x - pos.x)/(viewerDistance+pos.z)*viewerDistance, displayHeight/2 - (viewCenter.y - pos.y)/(viewerDistance+pos.z)*viewerDistance,
                r, r);
    }
    void drawCross(Point pos, float size) {
        line(pos.x - size/2f, pos.y, pos.x + size/2f, pos.y);
        line(pos.x, pos.y - size/2f, pos.x, pos.y + size/2f);
    }
    void drawStickMan(Point pos, float size) {
        Point p1 = new Point(pos.x, pos.y + size / 8f);
        Point p2 = new Point(pos.x, pos.y + size * 3 / 8);
        drawEllipse(pos, size / 4f);
        drawLine(p1, p2);
        drawLine(p1, new Point(p1.x-size/5, p1.y+size/4));
        drawLine(p1, new Point(p1.x+size/5, p1.y+size/4));
        drawLine(p2, new Point(p2.x-size/5, p2.y+size/2));
        drawLine(p2, new Point(p2.x+size/5, p2.y+size/2));
    }

    public void draw() {
        background(BLACK);
        keyAction();
        noFill();
        strokeWeight(1);
        stroke(WHITE);
        strokeWeight(2);
        text("A4: " + room.getA4(), 20,20 );
        text("room: " + room, 20, 50);
        text("center: " + viewCenter, 20, 150);
        rotTest.draw();
        room.draw();
        house.draw();
        house2.draw();
        //draw roof
        drawLine(house2.pos, roofTop);
        drawLine(house2.getA2(), roofTop);
        drawLine(house2.getA3(), roofTop);
        drawLine(house2.getA4(), roofTop);
        //draw roof2
        roofTop2.draw();
        drawLine(house.pos, roofTop2.p1);
        drawLine(house.getA4(), roofTop2.p1);
        drawLine(house.getA2(), roofTop2.p2);
        drawLine(house.getA3(), roofTop2.p2);
        //drawCenter
//        drawCross(new Point(displayWidth/2, displayHeight/2, 0), lengthUnit*30);
        drawStickMan(new Point(viewCenter.x, viewCenter.y, room_z/5), 100f);
    }

}
