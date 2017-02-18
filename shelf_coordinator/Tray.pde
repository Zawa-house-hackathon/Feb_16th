import java.util.Collections;

class Tray {
  ArrayList<Category> tray;

  Tray() {
    this.tray = new ArrayList<Category>();
  }

  Tray(JSONArray jsonArray) {
    this.tray = new ArrayList<Category>();
    for (int i = 0; i < jsonArray.size(); i++) this.add(new Category(jsonArray.getJSONObject(i)));
    Collections.sort(this.tray, new CategoryComparator());
  }

  void add(Category c) {
    this.tray.add(c);
  }

  void remove(int num) {
    this.tray.remove(num);
  }

  Category get(int num) {
    return this.tray.get(num);
  }

  int size() {
    return this.tray.size();
  }

  float width() {
    float w = 0;
    for (Category c : this.tray) {
      w += c.width;
    }
    return w;
  }

  float margin(float shelfWidth) {
    return shelfWidth - this.width();
  }

  void sort() {
    Collections.sort(this.tray, new CategoryComparator());
  }
}