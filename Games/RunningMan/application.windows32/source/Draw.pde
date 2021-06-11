public void draw() {
  
  background(200);
  image(mountainsBG, -300-(int)cam.pos.x/8, -300-(int)cam.pos.y/8);
  //draw all
  //GAME OVER BLACK
  if (state==GM.GAME_OVER) {
    background(0);
  }


  //draw RELATIVE to camera
  pushMatrix();
  translate(-cam.pos.x, -cam.pos.y);

  //move camera
  if(true)
    cam.update();

  //draw all objects

  for (Prefab prefab : prefabs) {
    prefab.update();
  }
  
  runner.update();
  
  for (Laser laser : lasers) {
    laser.update();
  }

  for (SolidRect rect : solidRects) {
    rect.update();
  }
  
  //only in editor
  if (state==GM.EDITOR) {
    if (selection!=null) selection.drawSelection();
    createRect.update();
  }
  popMatrix();


  //draw with FIXED position
  for(TextBox tb : textBoxes) {
    tb.update();
  }
  if (state==GM.MENU) {
    for (Button b : menuButtons) {
      b.update();
    }
  }
  if (state==GM.EDITOR) {
    keyActionEditor();
    for (int i = 0; i<editorButtons.length; i++) {
      Button b = editorButtons[i];
      if (tool==i) b.col = WHITE;
      else b.col = GREY;
      b.update();
    }
    for (Slider s : editorSliders) {
      s.update();
    } 
    //Save & Load
    saveButton.update();
    loadButton.update();
    for (int i = 0; i<mapButtons.length; i++) {
      Button b = mapButtons[i];
      if (mapNum==i) b.col = WHITE;
      else b.col = GREY;
      b.update();
    }
  }

  //open menu
  if (keyEsc) {
    if (state!=GM.MENU)
      state = GM.MENU;
    else
      state = GM.PLAY;
  }
  keyEsc = false;
  //RESTART
  if (keyR) {
    runner.health = 100;
    state = GM.PLAY;
    loadMap("map0"+mapNum+".txt");
  }
  //GAME OVER
  if (state==GM.GAME_OVER) {
    textAlign(CENTER, CENTER);
    textSize(100);
    fill(255);
    text("GAME OVER", width/2, height/4);
  }
  //stats
  fill(0);
  textSize(10);
  textAlign(LEFT, BOTTOM);
  text("x-Pos: " + runner.x, 10, height-10);
  text("y-Pos: " + runner.y, 10, height-20);
  text("x-Speed: " + runner.speed.x, 10, height-30);
  text("y-Speed: " + runner.speed.y, 10, height-40);
  text("lastXSpeed: " + lastXSpeed, 10, height-50);
  text("selected: " + selection, 10, height-60);
    text("mouseX: " + (mouseX+cam.pos.x), 10, height-70);
  text("mouseY: " + (mouseY+cam.pos.y), 10, height-80);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Health: " + runner.health, 10, 10);
  if (runner.speed.x!=0) lastXSpeed = runner.speed.x;
}
