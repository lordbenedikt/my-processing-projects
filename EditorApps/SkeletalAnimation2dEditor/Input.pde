float lastMouseX = mouseX;
float lastMouseY = mouseY;
float originalRotation;
PVector mouseAnchor = mousePos();
PVector selectionCenterAnchor = new PVector(0, 0);
PVector mouseMovement = new PVector();
PVector centerOfTransform;

PVector dragFrom;
boolean dragSelect = false;
Action action = Action.NONE;

enum Action {
  ROTATE,
    SCALE,
    MOVE,
    NONE,
}

ArrayList<Bone> selectedBones = new ArrayList<>();
Set<Integer> pressedKeys = new HashSet<Integer>();

void mousePressed() {
  dragFrom = new PVector(mouseX, mouseY);
}
void mouseDragged() {
  if (keyIsDown(CONTROL)) {
    return;
  }
  if (action == Action.NONE) {
    if (dist(dragFrom.x, dragFrom.y, mouseX, mouseY) > 10) {
      dragSelect = true;
    }
  }
}
void mouseReleased() {
  if (action != Action.NONE) {
    action = Action.NONE;
  } else if (dragSelect) {
    dragSelect = false;
    for (Bone bone : skeleton.bones) {
      // If SHIFT isn't down unselect all
      if (!keyIsDown(SHIFT)) {
        bone.unselect();
      }
      // Select/Unselect bones inside rubber band
      if (isInsideRect(bone.getGlobalPos(), dragFrom, new PVector(mouseX, mouseY))) {
        if (bone.isSelected) bone.unselect();
        else bone.select();
      }
    }
  } else {
    // If CONTROL is down create Bone
    if (keyIsDown(CONTROL)) {
      Bone parent = selectedBones.size() > 0 ?
        selectedBones.get(selectedBones.size()-1) :
        null;
      Bone newBone = createBone(parent);
      // Make only new bone selected
      for (Bone bone : skeleton.bones) {
        if (bone == newBone) {
          bone.select();
        } else {
          bone.unselect();
        }
      }
    } else {
      select();
    }
  }
}

void setSelectionCenterAnchor() {
  PVector topLeft = selectedBones.get(0).getGlobalPos().copy();
  PVector bottomRight = topLeft.copy();
  for (Bone bone : selectedBones) {
    var boneGlobalPos = bone.getGlobalPos();
    if (boneGlobalPos.x < topLeft.x) topLeft.x = boneGlobalPos.x;
    if (boneGlobalPos.y < topLeft.y) topLeft.y = boneGlobalPos.y;
    if (boneGlobalPos.x > bottomRight.x) bottomRight.x = boneGlobalPos.x;
    if (boneGlobalPos.y > bottomRight.y) bottomRight.y = boneGlobalPos.y;
  }
  selectionCenterAnchor = topLeft.copy().add(bottomRight).div(2);
}

void keyPressed() {
  setSelectionCenterAnchor();
  
  //add keys to list of pressed keys
  if (keyCode==SHIFT) pressedKeys.add(new Integer(SHIFT));
  if (keyCode==CONTROL) pressedKeys.add(new Integer(CONTROL));

  //move
  if (key=='g') {
    action = Action.MOVE;
  }

  //scale
  if (key=='s') {
    action = Action.SCALE;
    centerOfTransform = getCenter(selectedBones);
    mouseAnchor = mousePos();
    for (Bone bone : selectedBones) {
      bone.lengthBeforeTransformation = bone.length;
    }
  }

  //rotate
  if (key=='r') {
    if (selectedBones.size()!=0) {
      action = Action.ROTATE;
      centerOfTransform = getCenter(selectedBones);
      mouseAnchor = mousePos();
      for (Bone bone : selectedBones) {
        originalRotation = bone.rotation;
        bone.posBeforeTransformation = bone.pos.copy();
      }
    }
  }

  //delete
  if (key=='x') {
    skeleton.bones.removeAll(selectedBones);
    selectedBones.clear();
  }

  //add keyframe
  if (key=='k') {
  }
}

void keyReleased() {
  //remove keys from list of pressed keys
  if (keyCode==SHIFT) pressedKeys.remove(new Integer(SHIFT));
  if (keyCode==CONTROL) pressedKeys.remove(new Integer(CONTROL));
}

boolean keyIsDown(int pressedKey) {
  return pressedKeys.contains(pressedKey);
}
