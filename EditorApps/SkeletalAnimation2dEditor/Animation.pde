class Animation {
  boolean isPlaying = true;
  int passedFrames = 0;
  int keyframeLength = 120;
  ArrayList<Keyframe> keyframes = new ArrayList<>();
  Keyframe interpolatedFrame = new Keyframe(skinnedSkeleton.skeleton.bones);
  void addKeyframe() {
    keyframes.add(new Keyframe(skinnedSkeleton.skeleton.bones));
  }
  void interpolate() {
    if (!isPlaying || keyframes.size()==0) return;
    interpolatedFrame = new Keyframe(skinnedSkeleton.skeleton.bones);
    passedFrames = (passedFrames + 1) % (keyframeLength*keyframes.size());
    int keyframeAIndex = passedFrames / keyframeLength;
    var keyframeA = keyframes.get(keyframeAIndex);
    var keyframeB = keyframes.get((keyframeAIndex + 1) % keyframes.size());
    float x = 1 - (float(passedFrames % keyframeLength) / keyframeLength);
    for (var bone : skinnedSkeleton.skeleton.bones) {
      // Interpolate position
      var portionA = keyframeA.boneToTransformMap.get(bone).pos.copy().mult(x);
      var portionB = keyframeB.boneToTransformMap.get(bone).pos.copy().mult(1-x);
      interpolatedFrame.boneToTransformMap.get(bone).pos = portionA.add(portionB);
      // Interpolate rotation
      var rotA = keyframeA.boneToTransformMap.get(bone).rotation * x;
      var rotB = keyframeB.boneToTransformMap.get(bone).rotation * (1-x);
      interpolatedFrame.boneToTransformMap.get(bone).rotation = rotA + rotB;
      // Interpolate length
      var lengthA = keyframeA.boneToTransformMap.get(bone).length * x;
      var lengthB = keyframeB.boneToTransformMap.get(bone).length * (1-x);
      interpolatedFrame.boneToTransformMap.get(bone).length = lengthA + lengthB;
    }
  }
  Keyframe getInterpolatedFrame() {
    interpolate();
    return interpolatedFrame;
  }
}

class CombinedAnimation {
  HashMap<Animation, Float> weightedAnimation;
}

class Keyframe {
  HashMap<Bone, BoneTransform> boneToTransformMap = new HashMap<>();
  Keyframe() {}
  Keyframe(ArrayList<Bone> bones) {
    for (var bone : bones) {
      boneToTransformMap.put(bone, bone.copyTransform());
    }
  }
}

void applyTransform(Keyframe frame, float weight) {
  for(var bone : frame.boneToTransformMap.keySet()) {
    var transform = frame.boneToTransformMap.get(bone);
    bone.pos = transform.pos.copy().mult(weight);
    bone.rotation = transform.rotation * weight;
    bone.length = transform.length * weight;
  }
}

void applyTransformAdditive(Keyframe frame, float weight) {
  for(var bone : frame.boneToTransformMap.keySet()) {
    var transform = frame.boneToTransformMap.get(bone);
    bone.pos = transform.pos.copy().mult(weight).add(bone.pos);
    bone.rotation += transform.rotation * weight;
    bone.length += transform.length * weight;
  }
}
