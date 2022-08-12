void mouseMovement() {
  PVector movement = new PVector(mouseX-lastMouseX, mouseY-lastMouseY);
  lastMouseX = mouseX;
  lastMouseY = mouseY;
  mouseMovement = movement;
}
PVector mousePos() {
  return new PVector(mouseX, mouseY);
}
void editorAction() {
  // draw selectionBox
  if (dragSelect) {
    fill(255, 100);
    stroke(255);
    rect(dragFrom.x, dragFrom.y, mouseX-dragFrom.x, mouseY-dragFrom.y);
  }
  // MOVE selection
  if (action == Action.MOVE && !selectedBones.isEmpty()) {
    for (Bone bone : selectedBones) {
      var counterRotation = bone.parent==null ? 0 : -bone.parent.getGlobalRot();
      var transformedMouseMovement = mouseMovement.copy().rotate(counterRotation);
      bone.pos.x += transformedMouseMovement.x;
      bone.pos.y += transformedMouseMovement.y;
    }
  }
  // SCALE selected vertices
  if (action == Action.SCALE && !selectedBones.isEmpty()) {
    for (Bone bone : selectedBones) {
      PVector globalCenter = selectionCenterAnchor;
      float originalDistance = dist(globalCenter.x, globalCenter.y, mouseAnchor.x, mouseAnchor.y);
      float currentDistance = dist(globalCenter.x, globalCenter.y, mouseX, mouseY);
      float rescaleValue = currentDistance / originalDistance; 
      bone.length = bone.lengthBeforeTransformation * rescaleValue;
      //bone.pos.x = bone.beforeTransformation.x + (bone.beforeTransformation.x - centerOfTransform.x)*(mouseX-mouseAnchor.x-(mouseY-mouseAnchor.y))/100;
      //bone.pos.y = bone.beforeTransformation.y + (bone.beforeTransformation.y - centerOfTransform.y)*(mouseX-mouseAnchor.x-(mouseY-mouseAnchor.y))/100;
    }
  }
  // ROTATE selected vertices
  if (action == Action.ROTATE && !selectedBones.isEmpty()) {
    for (Bone bone : selectedBones) {
      PVector relativeToCenter = PVector.sub(bone.posBeforeTransformation, centerOfTransform);
      bone.rotation = originalRotation + (mouseX-mouseAnchor.x+mouseY-mouseAnchor.y)/100;
    }
  }
}
void select() {
  Bone closestBone = null;
  float shortestDistance = 9999f;
  for (Bone bone : skinnedSkeleton.skeleton.bones) {
    if (action != Action.NONE) return;
    if (keyIsDown(CONTROL)) {
      bone.unselect();
      return;
    }
    PVector center = new PVector(0, -bone.length/3).rotate(bone.getGlobalRot()).add(bone.getGlobalPos());
    var distance = dist(center.x, center.y, mouseX, mouseY);
    if (distance < shortestDistance && distance < bone.length/2) {
      shortestDistance = distance;
      closestBone = bone;
    } else {
      //add/substract to selection
      if (!keyIsDown(SHIFT))
        bone.unselect();
    }
  }
  if (closestBone != null) {
    if (closestBone.isSelected) {
      closestBone.unselect();
    } else {
      closestBone.select();
    }
  }
}
Bone createBone(Bone parent) {
  var mousePos = mousePos();
  Bone bone;
  if (parent==null) {
    bone = new Bone(null, mousePos.copy(), 0, 100f);
  } else {
    var endOfBone = parent.getEndOfBone();
    var angle = getAngle(mousePos.copy().sub(endOfBone)) - parent.getGlobalRot();
    bone = new Bone(
      parent,
      new PVector(0, 0),
      angle,
      endOfBone.copy().sub(mousePos).mag());
  }
  skinnedSkeleton.skeleton.addBone(bone);
  selectedBones.clear();
  bone.select();
  return bone;
}
PVector getCenter(ArrayList<Bone> bones) {
  if (bones.size()==0) return new PVector(0, 0);
  float minX = bones.get(0).pos.x;
  float minY = bones.get(0).pos.y;
  float maxX = bones.get(0).pos.x;
  float maxY = bones.get(0).pos.y;
  for (Bone bone : bones) {
    if (bone.pos.x < minX) minX = bone.pos.x;
    if (bone.pos.y < minY) minY = bone.pos.y;
    if (bone.pos.x > maxX) maxX = bone.pos.x;
    if (bone.pos.y > maxY) maxY = bone.pos.y;
  }
  PVector center = new PVector( (minX+maxX)/2, (minY+maxY)/2 );
  return center;
}
float getAngle(PVector vector) {
  if (vector.x>=0) {
    return PVector.angleBetween(new PVector(0, -1), vector);
  } else {
    return PVector.angleBetween(new PVector(0, 1), vector) + PI;
  }
}
float getDistanceToSegment( float x1, float y1, float x2, float y2, float x, float y ){
  PVector result = new PVector(); 
  
  float dx = x2 - x1; 
  float dy = y2 - y1; 
  float d = sqrt( dx*dx + dy*dy ); 
  float ca = dx/d; // cosine
  float sa = dy/d; // sine 
  
  float mX = (-x1+x)*ca + (-y1+y)*sa; 
  
  if( mX <= 0 ){
    result.x = x1; 
    result.y = y1; 
  }
  else if( mX >= d ){
    result.x = x2; 
    result.y = y2; 
  }
  else{
    result.x = x1 + mX*ca; 
    result.y = y1 + mX*sa; 
  }
  
  dx = x - result.x; 
  dy = y - result.y; 
  result.z = sqrt( dx*dx + dy*dy ); 
  
  return result.z;   
}
