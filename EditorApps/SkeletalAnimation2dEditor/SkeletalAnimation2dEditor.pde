import java.util.*;
import java.lang.Cloneable;

color colorSelected = color(255, 255, 255);
color colorDefault = color(252, 186, 3);
SkinnedSkeleton skinnedSkeleton = new SkinnedSkeleton();
ArrayList<SkinVertex[]> lines = new ArrayList<>();

boolean isPlaying = false;
ArrayList<Animation> animations = new ArrayList<>();
CombinedAnimation combinedAnimation = new CombinedAnimation();
int selectedAnimation = 1;
int animationCount = 1;
boolean additiveLayering = false;

void setup() {
  size(800, 600);
  animations.add(new Animation());
  skinnedSkeleton.skeleton
    .addBone(new Bone(null, new PVector(400, 300), 0, 100));
}

void draw() {
  background(100);

  // draw animation list
  for (int i = 1; i<=animationCount; i++) {
    float x = 10 + 30*(i-1);
    float y = 10;
    stroke(0);
    fill(i==selectedAnimation ? 255 : 100);
    rect(x, y, 20, 20);
    fill(0);
    textAlign(CENTER, CENTER);
    text(i, x+10, y+10);
  }

  if (isPlaying) {
    if (additiveLayering) {
      // Only applies with animationCount == 4;
      if (animationCount==4) {
        boolean first = true;
        float fullDistance = 200f;
        float upWeight = constrain(((height/2+fullDistance) - mouseY) / (fullDistance*2),0,1);
        float downWeight = 1 - upWeight;
        float leftWeight = constrain(((width/2+fullDistance) - mouseX) / (fullDistance*2),0,1);
        float rightWeight = 1 - leftWeight;
        
        float weightInfluence = constrain(dist(mouseX,mouseY,width/2,height/2)/fullDistance,0,1);
        
        float verticalness = (max(upWeight, downWeight)-0.5f) * 2f;
        float horizontalness = (max(leftWeight, rightWeight)-0.5f) * 2f;
        println("v" + verticalness);
        println("h" + horizontalness);
        upWeight = upWeight * verticalness;
        downWeight = downWeight * verticalness;
        leftWeight = leftWeight * horizontalness;
        rightWeight = rightWeight * horizontalness;
        
        float totalWeight = upWeight + downWeight + leftWeight + rightWeight;
        if (totalWeight!=0) {
          upWeight /= totalWeight;
          downWeight /= totalWeight;
          leftWeight /= totalWeight;
          rightWeight /= totalWeight;
        }
        println("up: " + upWeight + ", down: " + downWeight + ", left: " + leftWeight + ", right: " + rightWeight);
        for (int i = 0; i<4; i++) {
          float weight = 0;
          
          // choose correct weight
          if (i==0) weight = upWeight;
          else if (i==1) weight = downWeight;
          else if (i==2) weight = leftWeight;
          else weight = rightWeight;
          
          if (first) applyTransform(animations.get(i).getInterpolatedFrame(), weight);
          else applyTransformAdditive(animations.get(i).getInterpolatedFrame(), weight);
          first = false;
        }
      }
    } else {
      applyTransform(animations.get(selectedAnimation-1).getInterpolatedFrame(), 1f);
    }
  }
  mouseMovement();
  editorAction();
  skinnedSkeleton.skeleton.display();
  // draw mesh links
  for (var line : lines) {
    var pos1 = line[0].getPositionOnScreen();
    var pos2 = line[1].getPositionOnScreen();
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  // draw unassigned points
  for (var pos : skinnedSkeleton.screenPositions) {
    circle(pos.x, pos.y, 5);
  }
  // draw vertices
  skinnedSkeleton.skin.display();
}

class SkinnedSkeleton {
  Skeleton skeleton = new Skeleton();
  Skin skin = new Skin();
  ArrayList<PVector> screenPositions = new ArrayList<>();
  void generateSkin() {
    //screenPositions.clear();
    if (skeleton.bones.size()==0) return;
    PVector min = null;
    PVector max = null;
    for (var bone : skeleton.bones) {
      var globalPos = bone.getGlobalPos();
      var currentMin = new PVector(globalPos.x - bone.length*2f, globalPos.y - bone.length*2f);
      var currentMax = new PVector(globalPos.x + bone.length*2f, globalPos.y + bone.length*2f);
      if (min==null) {
        min = currentMin;
      } else {
        if (currentMin.x < min.x) min.x = currentMin.x;
        if (currentMin.y < min.y) min.y = currentMin.y;
      }
      if (max==null) {
        max = currentMax;
      } else {
        if (currentMax.x > max.x) max.x = currentMax.x;
        if (currentMax.y > max.y) max.y = currentMax.y;
      }
    }
    float meshSize = 20f;
    float maxDist = 50f;
    //for (float i = min.x; i<=max.x; i+=meshSize) {
    //  for (float j = min.y; j<=max.y; j+=meshSize) {
    //    for (var bone : skeleton.bones) {
    //      if (bone.distance(i, j) <= maxDist) {
    //        screenPositions.add(new PVector(i, j));
    //        break;
    //      }
    //    }
    //  }
    //}
    float maxWeightDist = maxDist*2;
    for (var point : screenPositions) {
      float summedDistance = 0f;
      ArrayList<Bone> closeBones = new ArrayList<>();
      float shortestDistance = 200f;
      for (var bone : skeleton.bones) {
        var distance = bone.distance(point.x, point.y);
        if (distance > maxWeightDist) continue;
        shortestDistance = distance;
        closeBones.add(bone);
        summedDistance += distance;
      }
      //println(closeBones.size());
      var newVertex = new SkinVertex();
      skin.vertexSpritePosMap.put(newVertex, null);
      for (var bone : closeBones) {
        var distance = bone.distance(point.x, point.y);
        var weight = pow(maxWeightDist - distance, 10);
        var weightVector = new WeightVector(bone.screenPosToRelPos(point), weight);
        newVertex.boneWeightMap.put(bone, weightVector);
      }
    }
    screenPositions.clear();
    skin.normalizeWeights();
  }
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

class BoneTransform {
  PVector pos;
  float rotation;
  float length;
  BoneTransform(Bone bone) {
    this.pos = bone.pos.copy();
    this.rotation = bone.rotation;
    this.length = bone.length;
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
  float influenceRadius;
  Bone(Bone parent, PVector pos, float rotation, float length) {
    this.parent = parent;
    this.pos = pos;
    this.rotation = rotation;
    this.length = length;
    this.influenceRadius = 50f;
  }
  BoneTransform copyTransform() {
    return new BoneTransform(this);
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
    PVector v = new PVector(0, -length).rotate(getGlobalRot());
    return getGlobalPos().add(v);
  }
  float getGlobalRot() {
    if (parent==null) return rotation;
    else return rotation + parent.getGlobalRot();
  }
  PVector relPosToScreenPos(PVector relativePosition) {
    return getGlobalPos().add(relativePosition.copy().rotate(getGlobalRot()));
  }
  PVector screenPosToRelPos(PVector screenPosition) {
    var diff = screenPosition.copy().sub(getGlobalPos());
    return diff.rotate(-getGlobalRot());
  }
  float distance(float x, float y) {
    PVector la = getGlobalPos();
    PVector lb = getEndOfBone();
    return getDistanceToSegment(la.x, la.y, lb.x, lb.y, x, y);
  }
}

class Skin {
  HashMap<SkinVertex, PVector> vertexSpritePosMap = new HashMap<>();
  void addVertex(SkinVertex vertex, PVector posOnSprite) {
    vertexSpritePosMap.put(vertex, posOnSprite);
  }
  void normalizeWeights() {
    for (var vertex : vertexSpritePosMap.keySet()) {
      vertex.normalizeWeights();
    }
  }
  void display() {
    for (var vertex : vertexSpritePosMap.keySet()) {
      var pos = vertex.getPositionOnScreen();
      fill(0);
      stroke(255);
      if (selectedBones.size()==1) {
        noStroke();
      }
      circle(pos.x, pos.y, 5);
      stroke(255);
    }
  }
}

class SkinVertex {
  HashMap<Bone, WeightVector> boneWeightMap = new HashMap<>();
  ArrayList<SkinVertex> neighbours = new ArrayList<>();
  void assignWeight(Bone bone, WeightVector weight) {
    boneWeightMap.put(bone, weight);
  }
  PVector getPositionOnScreen() {
    PVector res = new PVector(0, 0);
    for (var bone : boneWeightMap.keySet()) {
      var weightVector = boneWeightMap.get(bone);
      var resPortion = bone.relPosToScreenPos(weightVector.v).mult(weightVector.weight);
      res.add(resPortion);
    }
    return res;
  }
  void normalizeWeights() {
    if (boneWeightMap.isEmpty()) return;
    var totalWeight = 0f;
    // Calculate sum of all weights
    for (var weightVector : boneWeightMap.values()) {
      totalWeight += weightVector.weight;
    }
    // Divide weights by total weight to make the sum 1
    for (var weightVector : boneWeightMap.values()) {
      weightVector.weight = weightVector.weight / totalWeight;
    }
    //// Balance out floating point inaccuracy
    //for (var weightVector : boneWeightMap.values()) {
    //  weightVector.weight += 1f-newTotalWeight;
    //}
  }
}

// A vector with a specified weight
class WeightVector {
  PVector v;
  float weight;
  WeightVector(PVector v, float weight) {
    this.v = v;
    this.weight = weight;
  }
}
