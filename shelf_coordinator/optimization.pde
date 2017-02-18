Shelf optimization(JSONArray categoryJSON, JSONObject shelfJSON) {

  Shelf result = new Shelf(shelfJSON);
  Shelf frame  = new Shelf(shelfJSON);
  Tray  load   = new Tray (categoryJSON);

  // 横幅の合計が本棚よりも大きければ、差分を超えるもっとも小さいカテゴリーを削除する
  // ２つ以上消去する場合は小さいものから順に消していく
  /*
  int numParagraph = floor((_shelf.getFloat("height") + _shelf.getFloat("thin")) / (HEIGHT + _shelf.getFloat("thin")));
   float maxWidth = _shelf.getFloat("width") * numParagraph;
   float sumWidth = 0;
   for (Category c : _input) {
   sumWidth += c.width;
   }
   if (maxWidth < sumWidth) {
   float diff = sumWidth - maxWidth;
   for (int i = 0; i < _input.size(); i++) {
   if (_input.get(i).width < diff) continue;
   println(_input.get(i).title + "は本棚に入りませんでした");
   _input.remove(i);
   return optimization(_input, _shelf);
   }
   for (; diff < 0; diff -= _input.get(0).width) {
   println(_input.get(0).title + "は本棚に入りませんでした");
   _input.remove(0);
   }
   }
   */

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
  for (; load.size() != 0; ) {
    if (load.size() == 1) {
      Tray _tray = new Tray();
      _tray.add(new Category(load.get(0)));
      result.add(_tray);
      load.remove(0);
      break;
    }
    float sum = load.get(0).width + load.get(load.size()-1).width;
    if (sum > frame.width) {
      Tray _tray = new Tray();
      _tray.add(new Category(load.get(load.size()-1)));
      result.add(_tray);
      load.remove(load.size()-1);
    } else {
      Tray _tray = new Tray();
      _tray.add(new Category(load.get(0)));
      _tray.add(new Category(load.get(load.size()-1)));
      result.add(_tray);
      load.remove(0);
      load.remove(load.size()-1);
    }
  }

  return result;
}