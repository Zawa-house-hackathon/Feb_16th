import java.util.Collections;

static final float HEIGHT = 21;

void setup() {
  ArrayList<ArrayList<Category>> hoge = optimization(convert(loadJSONArray("Category.json")), loadJSONObject("shelf.json"));
  for (ArrayList<Category> array : sort(hoge)) {
    for (Category c : array) {
      print(c.name + "  ");
    }
    println();
  }
}

ArrayList<ArrayList<Category>> optimization(ArrayList<Category> _input, JSONObject _shelf) {

  ArrayList<ArrayList<Category>> result = new ArrayList<ArrayList<Category>>(); 
  // 横幅の合計が本棚よりも大きければ、差分を超えるもっとも小さいカテゴリーを削除する
  // ２つ以上消去する場合は小さいものから順に消していく
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
      println(_input.get(i).name + "は本棚に入りませんでした");
      _input.remove(i);
      return optimization(_input, _shelf);
    }
    for (; diff < 0; diff -= _input.get(0).width) {
      println(_input.get(0).name + "は本棚に入りませんでした");
      _input.remove(0);
    }
  }

  // 本棚の横幅を超えるカテゴリーは一列を埋め、余りを同様のジャンルとして扱う
  for (int i = 0; i < _input.size(); i++) {
    if (_input.get(i).width > _shelf.getFloat("width")) {
      ArrayList<Category> _array = new ArrayList<Category>();
      _array.add(new Category(_input.get(i), _shelf.getFloat("width")));
      result.add(_array);
      _input.get(i).reduceWidth(_shelf.getFloat("width"));
      i--;
      continue;
    }
  }
  Collections.sort(_input, new CategoryComparator());

  // 任意のカテゴリーと最小のカテゴリーの和が本棚の横幅を超える場合、そのカテゴリーで一列を埋める
  float tuppleWidth = _shelf.getFloat("width") - _input.get(0).width;
  for (int i = _input.size()-1; i > 0; i--) {
    if (_input.get(i).width > tuppleWidth) {
      ArrayList<Category> _array = new ArrayList<Category>();
      _array.add(new Category(_input.get(i)));
      result.add(_array);
      _input.remove(i);
    } else break;
  }

  // 残ったものの中から最適な組み合わせを見つける
  for (; _input.size() != 0; ) {
    if (_input.size() == 1) {
      ArrayList<Category> _array = new ArrayList<Category>();
      _array.add(new Category(_input.get(0)));
      result.add(_array);
      _input.remove(0);
      break;
    }
    float sum = _input.get(0).width + _input.get(_input.size()-1).width;
    if (sum > _shelf.getFloat("width")) {
      ArrayList<Category> _array = new ArrayList<Category>();
      _array.add(new Category(_input.get(_input.size()-1)));
      result.add(_array);
      _input.remove(_input.size()-1);
    } else {
      ArrayList<Category> _array = new ArrayList<Category>();
      _array.add(new Category(_input.get(0)));
      _array.add(new Category(_input.get(_input.size()-1)));
      result.add(_array);
      _input.remove(0);
      _input.remove(_input.size()-1);
    }
  }

  return result;
}

ArrayList<Category> convert(JSONArray _json) {
  ArrayList<Category> converted = new ArrayList<Category>();
  for (int i = 0; i < _json.size(); i++) converted.add(new Category(_json.getJSONObject(i)));
  Collections.sort(converted, new CategoryComparator());
  return converted;
}

ArrayList<ArrayList<Category>> sort(ArrayList<ArrayList<Category>> original) {
  ArrayList<ArrayList<Category>> sorted = new ArrayList<ArrayList<Category>>();
  for (; original.size() != 0; ) {
    boolean flag = true;
    for (int i = 0; i < original.size(); i++) {
      if (original.get(i).size() > 1) {
        flag = false;
        ArrayList<Category> top    = new ArrayList<Category>();
        ArrayList<Category> bottom = new ArrayList<Category>();
        for (int j = 0; j < original.get(i).size(); j++) {
          String _name = original.get(i).get(j).name;

          for (int k = 0; k < original.size(); k++) {
            if (i == k) continue;
            if (_name.equals(original.get(k).get(0).name)) {
              if (j == 0) {
                top = original.get(k);
                original.remove(k);
                i--;
              } else {
                bottom = original.get(k);
                original.remove(k);
                i--;
              }
            }
          }
        }
        if (top.size() != 0) sorted.add(top);
        sorted.add(original.get(i));
        if (bottom.size() != 0) sorted.add(bottom);
        original.remove(i);
      }
    }
    if (flag) {
      for (int i = 0; i < original.size(); i++) {
        sorted.add(original.get(i));
      }
      original.clear();
    }
  }
  return sorted;
}