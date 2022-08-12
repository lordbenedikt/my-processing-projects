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
  if (keyIsDown(CONTROL) || keyIsDown(ALT)) {
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
    for (Bone bone : skinnedSkeleton.skeleton.bones) {
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
      for (Bone bone : skinnedSkeleton.skeleton.bones) {
        if (bone == newBone) {
          bone.select();
        } else {
          bone.unselect();
        }
      }
      // If ALT is down create screenPoint
    } else if (keyIsDown(ALT)) {
      skinnedSkeleton.screenPositions.add(new PVector(mouseX,mouseY));
    } else {
      select();
    }
  }
}

void setSelectionCenterAnchor() {
  if (selectedBones.size()==0) return;
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
  pressedKeys.add(new Integer(keyCode));

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
    skinnedSkeleton.skeleton.bones.removeAll(selectedBones);
    selectedBones.clear();
  }

  // add keyframe
  if (key=='k') {
    animations.get(selectedAnimation-1).addKeyframe();
  }
  
  // play/stop animation
  if (key=='p') {
    isPlaying = !isPlaying;
  }

  // generate skin
  if (key=='m') {
    skinnedSkeleton.generateSkin();
  }

  // create lines
  if (key=='l') {
    if (lines.size()==0) {
      for (var vertex : skinnedSkeleton.skin.vertexSpritePosMap.keySet()) {
        var pos1 = vertex.getPositionOnScreen();
        for (var vertex2 : skinnedSkeleton.skin.vertexSpritePosMap.keySet()) {
          var pos2 = vertex2.getPositionOnScreen();
          if (dist(pos1.x, pos1.y, pos2.x, pos2.y) <= 30f) {
            lines.add(new SkinVertex[] {vertex, vertex2});
          }
        }
      }
    }
  }
  
  if (key=='0' || key=='1' || key=='2' || key=='3' || key=='4' || key=='5' || key=='6' || key=='7' || key=='8' || key=='9') {
    var number = key - '0';
    if (number<=animationCount) {
      selectedAnimation = number;
    }
  }
  
  // add animation
  if (key=='n') {
    if (animationCount<10) {
      animationCount++;
      animations.add(new Animation());
    }
  }
  
  // add animation
  if (key=='a') {
    additiveLayering = !additiveLayering;
  }
}

void keyReleased() {
  //remove keys from list of pressed keys
  if (pressedKeys.contains(new Integer(keyCode))) pressedKeys.remove(new Integer(keyCode));
}

boolean keyIsDown(int pressedKey) {
  return pressedKeys.contains(pressedKey);
}
