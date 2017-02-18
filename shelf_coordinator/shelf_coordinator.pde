static final float HEIGHT = 21;

Shelf hoge;

void setup() {
  size(900, 900);
  hoge = optimization(loadJSONArray("Category.json"), loadJSONObject("shelf.json"));
  hoge.sort();
  println(hoge);
}

void draw(){
  background(-1);
  scale(20, 5);
  for(int i = 0; i < hoge.size(); i++){
    float currentPosX = 0;
    fill(-1);
    rect(10, 10+i*HEIGHT, hoge.width, HEIGHT);
    for(int j = 0; j < hoge.get(i).size(); j++){
      fill(hoge.get(i).get(j).col);
      rect(10+currentPosX, 10+i*HEIGHT, hoge.get(i).get(j).width, hoge.get(i).get(j).height);
      currentPosX += hoge.get(i).get(j).width;
    }
  }
}