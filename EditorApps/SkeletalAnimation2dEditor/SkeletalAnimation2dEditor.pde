import java.util.*;

color colorSelected = color(255, 255, 255);
color colorDefault = color(252, 186, 3);
Skeleton skeleton;


void setup() {
  size(800, 600);
  skeleton = new Skeleton();
  skeleton
    .addBone(new Bone(null, new PVector(400, 300), 0, 100));
}

void draw() {
  background(100);
  mouseMovement();
  editorAction();
  skeleton.display();
}

class Skeleton {
  ArrayList<Bone> bones = new ArrayList<>();
  ArrayList<Animation> animations = new ArrayList<>();
  void display() {
    for (var bone : bones) {
      bone.display();
    }
  }
  void addBone(Bone bone) {
    bones.add(bone);
  }
}

class Bone {
  Bone parent;
  PVector pos;
  float rotation;
  float length;
  boolean isSelected = false;
  PVector posBeforeTransformation;
  float lengthBeforeTransformation;
  Bone(Bone parent, PVector pos, float rotation, float length) {
    this.parent = parent;
    this.pos = pos;
    this.rotation = rotation;
    this.length = length;
  }
  void display() {
    fill(isSelected ? colorSelected : colorDefault);
    stroke(isSelected ? colorSelected : colorDefault);
    pushMatrix();
    var globalPos = getGlobalPos();
    translate(globalPos.x, globalPos.y);
    rotate(getGlobalRot());
    line(0, 0, 0, -length);
    line(0, 0, -0.1*length, 0.3*-length);
    line(0, 0, 0.1*length, 0.3*-length);
    line(-0.1*length, 0.3*-length, 0, -length);
    line(0.1*length, 0.3*-length, 0, -length);
    line(-0.1*length, 0.3*-length, 0.1*length, 0.3*-length);
    rect(-2, -2, 4, 4);
    rect(-2, -2-length, 4, 4);
    popMatrix();
  }
  void select() {
    isSelected = true;
    if (!selectedBones.contains(this))
      selectedBones.add(this);
  }
  void unselect() {
    isSelected = false;
    if (selectedBones.contains(this))
      selectedBones.remove(this);
  }
  PVector getGlobalPos() {
    if (parent==null) return pos.copy();
    else {
      return parent.getEndOfBone().add(pos.copy().rotate(parent.getGlobalRot()));
    }
  }
  PVector getEndOfBone() {
    PVector v = new PVector(0,-length).rotate(getGlobalRot());
    return getGlobalPos().add(v);
  }
  float getGlobalRot() {
    if (parent==null) return rotation;
    else return rotation + parent.getGlobalRot();
  }
}

class Animation {
  HashMap<Bone, ArrayList<KeyFrame>> boneAnimations = new HashMap<>();
}

class KeyFrame {
  float time;
  PVector translation;
  float rotation;
  float scale;
  KeyFrame(PVector translation, float rotation, float scale) {
    this.translation = translation;
    this.rotation = rotation;
    this.scale = scale;
  }
}
