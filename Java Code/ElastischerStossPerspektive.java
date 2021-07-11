import processing.core.PApplet;
import processing.core.PGraphics;

import java.text.*;

import java.util.ArrayList;
import java.util.Random;

public class ElastischerStossPerspektive extends PApplet {

    public static void main(String[] args) {

        PApplet.runSketch(new String[]{"ElastischerStossPerspektive"}, new ElastischerStossPerspektive());
    }

    //setup
    int WINDOW_SIZE_X;      //horizontal window size
    int WINDOW_SIZE_Y;      //vertical window size
    int frameDelay = 1;
    int repeatStep = frameDelay;
    int collCheckRep = 1;
    //number of collision checks per frame
    double ballMaxSpeed = 3 * frameDelay;          //maximum random ball speed
    double ballMinSpeed = 1 * frameDelay;          //minimum random ball speed
    int ballMaxSize = 100;               //maximum random ball size
    int ballMinSize = 10;               //minimum random ball size     //delay between each frame, low number will increase speed and make animation more smooth
    float diskHeight = 15;
    double gravity = 0;               //downward gravity :D
    double airFriction = 1;             //constant speed reduction by percentage
    double bounceFriction = 30;         //speed reduction when balls hit each other (not implemented)
    double floorFriction = 20;          //speed reduction when hitting a border
    double movingSpeed = 0.65;            //acceleration of own ball when pressing arrow keys
    int ballNumber = 15;
    ArrayList<Ball> baelle = new ArrayList<>();       //number of balls

    boolean draw3D = true;

    boolean keyUp = false;
    boolean keyDown = false;
    boolean keyLeft = false;
    boolean keyRight = false;
    boolean keySpace = false;
    boolean keyT = false;
    boolean keyPlus = false;
    boolean keyMinus = false;
    boolean keyD = false;

    double nSpeedDiff = 0;
    double nSpeed_t = 0;
    double nSpeed_o = 0;

    DecimalFormat df2 = new DecimalFormat("#.##");
    DecimalFormat df0 = new DecimalFormat("#");

    public void settings() {
        fullScreen();
        WINDOW_SIZE_X = displayWidth;
        WINDOW_SIZE_Y = displayHeight;
//        size(WINDOW_SIZE_X, WINDOW_SIZE_Y);
    }

    public void setup() {
        createAllBalls();
        baelle.get(0).rad = 70;
        baelle.get(1).rad = 30;
        baelle.get(0).ySpeed = 0;
        baelle.get(1).ySpeed = 0;
        baelle.get(1).y = baelle.get(0).y;
        background(THMGreen);
        noStroke();
    }

    Random ran = new Random();

    int cCount = 0;
    double nAngle2;
    double tAngle2;

    class Ball {
        double x;
        double y;
        double rad;
        double xSpeed;
        double ySpeed;

        Ball(double x, double y, double rad, double speed, double angle) {
            this.x = x;
            this.y = y;
            this.rad = rad;
            this.xSpeed = getXSpeed(speed, angle);
            this.ySpeed = getYSpeed(speed, angle);
        }
    }

    public Ball createBall() {
        int rad;
        return new Ball(ran.nextInt((int) (WINDOW_SIZE_X - 2 * (rad = ran.nextInt(ballMaxSize - ballMinSize) + ballMinSize)) + rad),
                ran.nextInt((int) (WINDOW_SIZE_Y - 2 * rad)) + rad,
                rad,
                ran.nextDouble() * (ballMaxSpeed - ballMinSpeed) + ballMinSpeed,
                ran.nextDouble() * 2 * Math.PI);
    }

    public void createAllBalls() {
        for (int i = 0; i < ballNumber; i++) {
            baelle.add(createBall());
        }
    }

    // Colors
    int THMGreen = color(128, 186, 36);
    int THMGrey = color(74, 92, 102);
    int WHITE = color(256, 256, 256);
    int SHADOW = color(0, 50);
    int THMRed = color(184, 0, 64);
    int PURPLE = color(0, 0, 255);
    int YELLOW = color(255, 255, 0);

    public void keyPressed() {
        if (keyCode == UP) keyUp = true;
        if (keyCode == DOWN) keyDown = true;
        if (keyCode == LEFT) keyLeft = true;
        if (keyCode == RIGHT) keyRight = true;
        if (key == ' ') keySpace = true;
        if (key == 't') keyT = true;
        if (key == '+') keyPlus = true;
        if (key == '-') keyMinus = true;
        if (key == 'd') keyD = true;
    }

    public void keyReleased() {
        if (keyCode == UP) keyUp = false;
        if (keyCode == DOWN) keyDown = false;
        if (keyCode == LEFT) keyLeft = false;
        if (keyCode == RIGHT) keyRight = false;
        if (key == ' ') keySpace = false;
        if (key == 't') keyT = false;
        if (key == '+') keyPlus = false;
        if (key == '-') keyMinus = false;
        if (key == 'd') keyD = false;
    }

    public void keyAction() {
        if (keyUp == true) baelle.get(0).ySpeed -= movingSpeed;
        if (keyDown == true) baelle.get(0).ySpeed += movingSpeed;
        if (keyLeft == true) baelle.get(0).xSpeed -= movingSpeed;
        if (keyRight == true) baelle.get(0).xSpeed += movingSpeed;
        if (keySpace == true) baelle.get(0).ySpeed -= 10 * movingSpeed;
        if (keyT == true) scaleSpeed(baelle.get(0), 1.2);
        if (keyPlus == true) {
            baelle.add(createBall());
            keyPlus = false;
        }
        if (keyMinus == true) {
            if (baelle.size() > 1)
                baelle.remove(1);
            keyMinus = false;
        }
        if (keyD == true) {
            draw3D = !draw3D;
            keyD = false;
        }
    }

    public double getAngle(double x, double y) {

        // to prevent division through 0
        if (y == 0) {
            if (x < 0) return Math.PI;
            if (x > 0) return 0;
        }

        if (x >= 0 && y < 0) return 2 * Math.PI - Math.atan(x / y) - Math.PI / 2 % (2 * Math.PI);
        if (x >= 0 && y > 0) return Math.PI / 2 - Math.atan(x / y);
        if (x < 0 && y > 0) return Math.PI / 2 - Math.atan(x / y);
        if (x < 0 && y < 0) return 1.5 * Math.PI - Math.atan(x / y);
        return 0;
    }

    public double getAngle(Ball b) {
        return getAngle(b.xSpeed, b.ySpeed);
    }

    public double getAngleAspect(double xSpeed, double ySpeed, double Angle) {
        double res = Math.cos(Angle) * xSpeed + Math.cos(Angle - Math.PI / 2) * ySpeed;
        //                     Speed (x-Element)                    Speed (y-Element)
        return res;
    }

    public double surArea(Ball b) {
        return Math.pow(b.rad, 2);
    }

    public double getSpeed(double xSpeed, double ySpeed, double Angle) {
        double res = Math.cos(Angle - 0.5 * Math.PI) * xSpeed + Math.cos(Math.PI - Angle) * ySpeed;
        //                     Speed (x-Element)                    Speed (y-Element)
        return res;
    }

    public double getSpeed(double xSpeed, double ySpeed) {
        return Math.sqrt(Math.pow(xSpeed, 2) + Math.pow(ySpeed, 2));
    }

    public double getSpeed(Ball b) {
        return getSpeed(b.xSpeed, b.ySpeed);
    }

    public void setSpeed(Ball b, double speed) {
        b.xSpeed = getXSpeed(speed, getAngle(b));
        b.ySpeed = getYSpeed(speed, getAngle(b));
    }

    public double getXSpeed(double speed, double angle) {
        return Math.cos(angle) * speed;
    }

    public double getYSpeed(double speed, double angle) {
        return Math.sin(angle) * speed;
    }

    public void scaleSpeed(Ball b, double amount) {
        double checkSpeed = getSpeed(b);
        double checkAngle = getAngle(b);
        b.xSpeed = getXSpeed(checkSpeed * amount, checkAngle);
        b.ySpeed = getYSpeed(checkSpeed * amount, checkAngle);
    }

    public double pointDirection(double x1, double y1, double x2, double y2) {
        return getAngle(x2 - x1, y2 - y1);
    }

    private boolean colliding(Ball a, Ball b) {
        if (a != b) {
            double d = Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2));
            return d + 0.5 <= a.rad + b.rad;
        } else return false;
    }

    public double getDistance(Ball a, Ball b) {
        return Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2));
    }

    public void distanceCorrection(Ball a, Ball b) {
        double dis = getDistance(a, b);
        double angle = getAngle(b.x - a.x, b.y - a.y);
        double minDis = a.rad + b.rad;
        double disX = b.x - a.x;
        double disY = b.y - a.y;
        double m_a = Math.PI * Math.pow(a.rad, 2);
        double m_b = Math.PI * Math.pow(b.rad, 2);
        double m_tot = m_a + m_b;
        if (colliding(a, b)) {

//              disregard mass
//            a.x -= getXSpeed((minDis - dis)/2.0, angle);
//            a.y -= getYSpeed((minDis - dis)/2.0, angle);
//            b.x += getXSpeed((minDis - dis)/2.0, angle);
//            b.y += getYSpeed((minDis - dis)/2.0, angle);

            //  correction rate proportional to mass
            double aXCor = -(m_b / m_tot) * getXSpeed(minDis - dis, angle);
            double aYCor = -(m_b / m_tot) * getYSpeed(minDis - dis, angle);
            a.x += aXCor;
            a.y += aYCor;
            b.x += getXSpeed(minDis - dis, angle) + aXCor;
            b.y += getYSpeed(minDis - dis, angle) + aYCor;
        }
    }

    public void bounce(Ball t, Ball o) {
        if (colliding(t, o)) {
            cCount += 1;
            distanceCorrection(t, o);

            double nAngle = pointDirection(t.x, t.y, o.x, o.y);
            double tAngle = nAngle - Math.PI / 2.0;
            double tSpeed_t = getAngleAspect(t.xSpeed, t.ySpeed, tAngle);
            nSpeed_t = getAngleAspect(t.xSpeed, t.ySpeed, nAngle);
            double tSpeed_o = getAngleAspect(o.xSpeed, o.ySpeed, tAngle);
            nSpeed_o = getAngleAspect(o.xSpeed, o.ySpeed, nAngle);
            double nextNSpeed_t;
            double nextNSpeed_o;

            double m1 = Math.PI * Math.pow(t.rad, 2);
            double v1 = nSpeed_t;
            double m2 = Math.PI * Math.pow(o.rad, 2);
            double v2 = nSpeed_o;

            //for print statement
            tAngle2 = tAngle;
            nAngle2 = nAngle;

//            nextNSpeed_t = nSpeed_t;
//            nextNSpeed_o = nSpeed_o;
//            nextNSpeed_t = (m1*v1 + m2*(2*v2-v1) )
//                            /  (m1 + m2);
//            nextNSpeed_o = (m2*v2 + m1*(2*v1-v2) )
//                            /  (m2 + m1);

            //get Speed towards each other
            nSpeedDiff = Math.abs(nSpeed_t - nSpeed_o);

            nextNSpeed_t = (Math.PI * Math.pow(t.rad, 2) * nSpeed_t + Math.PI * Math.pow(o.rad, 2) * (2 * nSpeed_o - nSpeed_t))
                    / (Math.PI * Math.pow(t.rad, 2) + Math.PI * Math.pow(o.rad, 2));
            nextNSpeed_o = (Math.PI * Math.pow(o.rad, 2) * nSpeed_o + Math.PI * Math.pow(t.rad, 2) * (2 * nSpeed_t - nSpeed_o))
                    / (Math.PI * Math.pow(o.rad, 2) + Math.PI * Math.pow(t.rad, 2));

            //reduce Speed
//            double percent = 0.01*bounceFriction;
//            if ( nSpeedDiff > 2.0 ) {
//                if (nextNSpeed_t > 1.0*bounceFriction) nextNSpeed_t = nextNSpeed_t*(1.0 - 1.0*percent); else nextNSpeed_t = 0;
//            }
//            if ( nSpeedDiff > 2.0 ) {
//                if (nextNSpeed_o > 1.0*bounceFriction) nextNSpeed_o = nextNSpeed_o*(1.0 - 1.0*percent); else nextNSpeed_o = 0;
//            }
            // needs to be reduced proportional to relative nSpeed !!! (nextNSpeed = absolute nSpeed)


            t.xSpeed = getXSpeed(nextNSpeed_t, nAngle) + getXSpeed(tSpeed_t, tAngle);
            t.ySpeed = getYSpeed(nextNSpeed_t, nAngle) + getYSpeed(tSpeed_t, tAngle);
            o.xSpeed = getXSpeed(nextNSpeed_o, nAngle) + getXSpeed(tSpeed_o, tAngle);
            o.ySpeed = getYSpeed(nextNSpeed_o, nAngle) + getYSpeed(tSpeed_o, tAngle);
        }
    }

    private boolean hitTop(Ball b) {
        if (b.ySpeed < 0) if (b.y - b.rad <= 0) return true;
        return false;
    }

    private boolean hitRight(Ball b) {
        if (b.xSpeed > 0) if (b.x + b.rad >= WINDOW_SIZE_X) return true;
        return false;
    }

    private boolean hitBottom(Ball b) {
        if (b.ySpeed > 0) if (b.y + b.rad >= WINDOW_SIZE_Y) return true;
        return false;
    }

    private boolean hitLeft(Ball b) {
        if (b.xSpeed < 0) if (b.x - b.rad <= 0) return true;
        return false;
    }

    public void reduceSpeed(Ball b, double percent, int dir) {
        // direction: 0 = horizontal, 1 = vertical, 2 = total
        percent = 0.01 * percent;
        double amount = Math.pow((1.0 - (1.0 * percent)), frameDelay);  //frameDelay counters changes of the frame rate
        if (dir == 0) {
            if (b.xSpeed > 1.0 * percent) b.xSpeed = b.xSpeed * amount;
            else if (b.xSpeed < -1.0 * percent) b.xSpeed = b.xSpeed * amount;
            else b.xSpeed = 0;
        }
        if (dir == 1) {
            if (b.ySpeed > 1.0 * percent) b.ySpeed = b.ySpeed * amount;
            else if (b.ySpeed < -1.0 * percent) b.ySpeed = b.ySpeed * amount;
            else b.ySpeed = 0;
        }
        if (dir == 2) {
            double sp = getSpeed(b);
            if (sp > 10.0 * percent) sp = sp * amount;
            else sp = 0;
            setSpeed(b, sp);
        }
    }

    public void bounceWall(Ball b) {
        if (hitTop(b) | hitBottom(b)) {
            reduceSpeed(b, floorFriction, 1);
            b.ySpeed = -b.ySpeed;
        }
        if (hitLeft(b) | hitRight(b)) {
            reduceSpeed(b, floorFriction, 0);
            b.xSpeed = -b.xSpeed;
        }
        // Correct if outside window
        if (b.x - b.rad < 0) b.x = b.rad;
        if (b.x + b.rad > WINDOW_SIZE_X) b.x = WINDOW_SIZE_X - b.rad;
        if (b.y - b.rad < 0) b.y = b.rad;
        if (b.y + b.rad > WINDOW_SIZE_Y) b.y = WINDOW_SIZE_Y - b.rad;
    }

    public void step() {    //calculate next frame
        keyAction();
        for (int i = 0; i < baelle.size(); i++) {

//            reduceSpeed(baelle[i], airFriction, 2);

            double sp = getSpeed(baelle.get(i));
            double percent = 0.01 * airFriction;
            if (sp > 10.0 * percent) sp = sp * (1.0 - 1.0 * percent);
            else sp = 0;
            setSpeed(baelle.get(i), sp);

            //gravity
            baelle.get(i).ySpeed += gravity;

            baelle.get(i).x = baelle.get(i).x + baelle.get(i).xSpeed;
            baelle.get(i).y = baelle.get(i).y + baelle.get(i).ySpeed;
        }
        for (int rep = 0; rep < collCheckRep; rep++) {
            for (int i = 0; i < baelle.size(); i++) {
                bounceWall(baelle.get(i));
                for (int j = 0; j < baelle.size(); j++) {
                    if (i != j) bounce(baelle.get(i), baelle.get(j));
                }
            }
        }
    }

    public void draw() {

        for (int i = 0; i < repeatStep; i++) {
            step();
        }

        background(THMGreen);   // Clear background

        // draw baelle
        // draw shadow
        if (draw3D) {
            fill(SHADOW);
            for (int i = 0; i < baelle.size(); i++) {
                ellipse((float) baelle.get(i).x + 0.7f * diskHeight * (float) baelle.get(i).rad / 50,
                        (float) baelle.get(i).y + 0.7f * diskHeight * (float) baelle.get(i).rad / 50,
                        (float) baelle.get(i).rad * 2, (float) baelle.get(i).rad * 2);
            }
            // draw side
            fill(WHITE);
            for (int i = 0; i < baelle.size(); i++) {
                ellipse((float) baelle.get(i).x, (float) baelle.get(i).y, (float) baelle.get(i).rad * 2, (float) baelle.get(i).rad * 2);
                fill(SHADOW);
                ellipse((float) baelle.get(i).x, (float) baelle.get(i).y, (float) baelle.get(i).rad * 2, (float) baelle.get(i).rad * 2);
                fill(THMRed);
            }
            // draw top
            fill(WHITE); //self color
            for (int i = 0; i < baelle.size(); i++) {
                ellipse((float) (baelle.get(i).x - baelle.get(i).rad / 50 * diskHeight * ((WINDOW_SIZE_X / 2 - baelle.get(i).x) / (WINDOW_SIZE_X * 0.5))),
                        (float) (baelle.get(i).y - baelle.get(i).rad / 50 * diskHeight * ((WINDOW_SIZE_Y / 2 - baelle.get(i).y) / (WINDOW_SIZE_X * 0.5f))),
                        (float) baelle.get(i).rad * 2, (float) baelle.get(i).rad * 2);
                fill(THMRed);           // Color
            }
        }
        else {
            fill(WHITE);
            for (int i = 0; i < baelle.size(); i++) {
                ellipse((float) baelle.get(i).x, (float) baelle.get(i).y, (float) baelle.get(i).rad * 2, (float) baelle.get(i).rad * 2);
                fill(THMRed);
            }
        }
        fill(0);
        text("Speed: " + df2.format(getSpeed(baelle.get(0))), 12, 20);
        text("ySpeed: " + df2.format(baelle.get(0).ySpeed - (baelle.get(0).ySpeed % 0.01)), 12, 35);
        text("xSpeed: " + df2.format(baelle.get(0).xSpeed - (baelle.get(0).xSpeed % 0.01)), 12, 50);
        text("collisionCount: " + cCount, 12, 65);

        text("Angle: " + df0.format(Math.toDegrees(getAngle(baelle.get(0)))) + "\u00B0", 12, 85);
        text("nAngle: " + df0.format(Math.toDegrees(nAngle2)) + "\u00B0", 12, 100);
        text("tAngle: " + df0.format(Math.toDegrees((tAngle2 + 2 * Math.PI) % (2 * Math.PI))) + "\u00B0", 12, 115);
        text("nSpeedDiff: " + df2.format(nSpeedDiff), 12, 130);
        text("nSpeed_t: " + df2.format(nSpeed_t), 12, 145);
        text("nSpeed_o: " + df2.format(nSpeed_o), 12, 160);
        text("Benutzt die Pfeiltasten, um euren eigenen Ball zu steuern! :)", 12, WINDOW_SIZE_Y - 20);

        delay(frameDelay);
    }

}


//    public void keyPressed() {
//        if (key == CODED) {
//            if (keyCode == UP) ySpeed[0] -= 1;
//            if (keyCode == DOWN) ySpeed[0] += 1;
//            if (keyCode == LEFT) xSpeed[0] -= 1;
//            if (keyCode == RIGHT) xSpeed[0] += 1;
//        }
//    }

//    public int hitWall(Ball b) {
//        // 0 = no collision 1 = top, 2 = right, 3 = bottom, 4 = left, 5 = left+top, 6 = top+right, 7 = right+bottom, 8 = bottom+left
//        if (hitTop(b)) {       //top
//            if (hitLeft(b)) return 5;
//            if (hitRight(b)) return 6;
//            return 1;
//        }
//        if (hitBottom(b)) {       //right
//            if (hitRight(b)) return 7;
//            if (hitLeft(b)) return 8;
//            return 3;
//        }
//        if (hitRight(b)) {       //bottom
//            return 2;
//        }
//        if (hitLeft(b)) {       //left
//            return 4;
//        }
//        return 0;
//    }
//
//    public void bounceWall(Ball b) {

//        int dir = hitWall(b);
//        //vertical bounce
//        if ( dir == 1 | dir == 3 | (dir >= 5 && dir <= 8) ) b.ySpeed = -b.ySpeed;
//        //horizontal bounce
//        if ( dir == 2 | dir == 4 | (dir >= 5 && dir <= 8) ) b.xSpeed = -b.xSpeed;
//    }
