Candidate storing(Shelf frame, Tray loads) {
  Candidate stock = new Candidate(frame);
  stock.add(new Tray());
  for (Category load : loads.tray) {
    if (stock.margin(0) >= load.width) {
      stock.add(0, load);
    } else {
      stock.add(0, new Tray());
      stock.add(0, load);
    }
  }
  return stock;
}