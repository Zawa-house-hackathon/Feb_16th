class Category {
  String name;
  float  height = HEIGHT;
  float  width;
  Category(JSONObject _json) {
    this.name   = _json.getString("title");
    this.width  = _json.getFloat("width");
  }
  
  Category(Category _c) {
    this.name   = _c.name;
    this.width  = _c.width;
  }
  
  Category(Category _c, float _width) {
    this.name   = _c.name;
    this.width  = _width;
  }
  
  void reduceWidth(float _diff){
    this.width -= _diff;
  }
}

import java.util.Comparator;

class CategoryComparator implements Comparator<Category> {
  public int compare(Category c1, Category c2) {
    return int(c1.width - c2.width);
  }
}