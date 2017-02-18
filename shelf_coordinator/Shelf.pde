class Shelf {
  ArrayList<Tray> shelf;
  float width;
  float height;
  float thickness;

  Shelf(JSONObject json) {
    this.shelf     = new ArrayList<Tray>();
    this.width     = json.getFloat("width");
    this.height    = json.getFloat("height");
    this.thickness = json.getFloat("thickness");
  }

  Shelf(Shelf original) {
    this.shelf     = new ArrayList<Tray>();
    this.width     = original.width;
    this.height    = original.height;
    this.thickness = original.thickness;
  }

  void add(Tray t) {
    this.shelf.add(t);
  }

  void add(int stage, Category c) {
    try {
      this.shelf.get(stage).add(c);
    }
    catch(IndexOutOfBoundsException e) {
      e.printStackTrace();
    }
  }

  Tray get(int stage) {
    return this.shelf.get(stage);
  }

  void remove(int stage) {
    this.shelf.remove(stage);
  }

  void clear() {
    this.shelf.clear();
  }

  int size() {
    return this.shelf.size();
  }

  void sort() {
    Shelf sorted = new Shelf(this);
    for (; this.size() != 0; ) {
      boolean flag = true;
      for (int i = 0; i < this.size(); i++) {
        if (this.get(i).size() > 1) {
          flag = false;
          Tray top    = new Tray();
          Tray bottom = new Tray();
          for (int j = 0; j < this.get(i).size(); j++) {
            String _name = this.get(i).get(j).title;

            for (int k = 0; k < this.size(); k++) {
              if (i == k) continue;
              if (_name.equals(this.get(k).get(0).title)) {
                if (j == 0) {
                  top = this.get(k);
                  this.remove(k);
                  i--;
                } else {
                  bottom = this.get(k);
                  this.remove(k);
                  i--;
                }
              }
            }
          }
          if (top.size() != 0) sorted.add(top);
          sorted.add(this.get(i));
          if (bottom.size() != 0) sorted.add(bottom);
          this.remove(i);
        }
      }
      if (flag) {
        for (int i = 0; i < this.size(); i++) {
          sorted.add(this.get(i));
        }
        this.clear();
      }
    }
    this.shelf = sorted.shelf;
  }
}