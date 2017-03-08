void print(Category c) {
  print(c.title);
}

void print(Tray t) {
  for (Category c : t.tray) {
    print(c.title + " ");
  }
}

void print(Shelf s) {
  for (Tray t : s.shelf) {
    for (Category c : t.tray) {
      print(c.title + " ");
    }
    println("");
  }
}

void println(Category c) {
  println(c.title);
}

void println(Tray t) {
  for (Category c : t.tray) {
    print(c.title + " ");
  }
  println("");
}

void println(Shelf s) {
  for (Tray t : s.shelf) {
    for (Category c : t.tray) {
      print(c.title + " " + c.width + " ");
    }
    println("");
  }
}

void println(Optimizer o, int order) {
  for(int i = 0; i < order; i++){
    println(o.permList.get(i).evaluate);
    println(o.permList.get(i));
  }
}