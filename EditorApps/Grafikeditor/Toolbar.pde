Toolbar toolbar;

PImage toolbarCircle;
PImage toolbarRect;
PImage toolbarLine;
PImage toolbarEllipse;
PImage toolbarBucket;

class Toolbar {
  float x;
  float y;
  ToolbarItem items[];
  Toolbar(float x, float y, ToolbarItem[] items) {
    this.x = x;
    this.y = y;
    this.items = items;
  }
  void drawThis() {
    float currentY = y;
    for (ToolbarItem item : items) {
      item.x = x;
      item.y = currentY;
      item.drawThis();
      currentY += item.h;
    }
  }
}

class ToolbarItem {
  PImage img;
  float w;
  float h;
  float x;
  float y;
  Tool tool;
  ToolbarItem(PImage img, float w, float h, Tool tool) {
    this.img = img;
    this.w = w;
    this.h = h;
    this.tool = tool;
  }
  void drawThis() {
    if (selectedTool==tool) {
      tint(255, 250, 180);
    }
    boolean isDown = selectedTool==tool || (mouseInRect(x, y, w, h)&&toolbarAction);
    button(x, y, w, h, isDown, 2);
    image(img, x, y, w, h);
    noTint();
  }
  void click() {
    if (mouseInRect(x, y, w, h)) {
      toolbarAction = true;
      if (tool==Tool.FILL_BACKGROUND) {
        backgroundColor = selectedFillColor;
      } else {
        selectedTool = tool;
      }
    }
  }
}

void createToolbar() {
  int toolItemWidth = 40;
  ToolbarItem toolbarItems[] = {
    new ToolbarItem(toolbarLine, toolItemWidth, toolItemWidth, Tool.LINE), 
    new ToolbarItem(toolbarCircle, toolItemWidth, toolItemWidth, Tool.CIRCLE), 
    new ToolbarItem(toolbarRect, toolItemWidth, toolItemWidth, Tool.RECT), 
    new ToolbarItem(toolbarEllipse, toolItemWidth, toolItemWidth, Tool.ELLIPSE), 
    new ToolbarItem(toolbarBucket, toolItemWidth, toolItemWidth, Tool.FILL_BACKGROUND)
  };
  toolbar = new Toolbar(0, 180, toolbarItems);
}
