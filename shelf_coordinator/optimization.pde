Shelf optimization(JSONArray categoryJSON, JSONObject shelfJSON) {

  Shelf result = new Shelf(shelfJSON);
  Shelf frame  = new Shelf(shelfJSON);
  Tray  load   = new Tray (categoryJSON);

  // 本棚の横幅を超えるカテゴリーは一列を埋め、余りを同様のジャンルとして扱う
  for (int i = 0; i < load.size(); i++) {
    if (load.get(i).width > frame.width) {
      Tray _tray = new Tray();
      _tray.add(new Category(load.get(i), frame.width));
      result.add(_tray);
      load.get(i).reduceWidth(frame.width);
      i--;
      continue;
    }
  }

  load.sort();

  // 任意のカテゴリーと最小のカテゴリーの和が本棚の横幅を超える場合、そのカテゴリーで一列を埋める
  float setWidth = frame.width - load.get(0).width;
  for (int i = load.size()-1; i > 0; i--) {
    if (load.get(i).width > setWidth) {
      Tray _tray = new Tray();
      _tray.add(new Category(load.get(i)));
      result.add(_tray);
      load.remove(i);
    } else break;
  }

  // 残ったものの中から最適な組み合わせを見つける
  Optimizer opt = new Optimizer(frame, load);
  for(Tray _tray : opt.permList.get(0).shelf){
    result.add(_tray);
  }

  return result;
}