class Category {
  String title;
  float  height;
  float  width;
  color  col;
  Category(JSONObject _json) {
    this.title  = _json.getString("title");
    this.height = _json.getFloat("height");
    this.width  = _json.getFloat("width");
    this.col    = color((int)random(0, 255), (int)random(0, 255), (int)random(0, 255));
  }

  Category(Category _c) {
    this.title  = _c.title;
    this.height = _c.height;
    this.width  = _c.width;
    this.col    = _c.col;
  }

  Category(Category _c, float _width) {
    this.title  = _c.title;
    this.height = _c.height;
    this.width  = _width;
    this.col    = _c.col;
  }

  void reduceWidth(float _diff) {
    this.width -= _diff;
  }
}

import java.util.Comparator;

class CategoryComparator implements Comparator<Category> {
  public int compare(Category c1, Category c2) {
    return int(c1.width - c2.width);
  }
}