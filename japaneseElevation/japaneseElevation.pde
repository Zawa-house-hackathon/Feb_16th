//矩形領域に日本地図の標高を表示する
//JSONObject json;
//日本
//東経 128~145
//北緯 45 ~30

float getElevation(float lon, float lat){
  processing.data.JSONObject json;
  json = loadJSONObject("http://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?lon="+lon+"&lat="+lat+"&outtype=JSON");
  
  String str = json.toString();
  str = str.substring(str.indexOf(":")+3);
  if(str.charAt(0)=='-') return -1;
  println(json.getFloat("elevation"));
  return json.getFloat("elevation");
}

float[][] getAroundElevMap(float clon, float clat, int imgL, float regL){
  float[][] ret = new float[imgL][imgL];
  for(int i = 0; i < imgL; i++){
    for(int j = 0; j < imgL; j++){
      float lon = clon + (regL*(i-imgL/2))/imgL/2;
      float lat = clat - (regL*(j-imgL/2))/imgL/2;
      float elev = getElevation(lon, lat);
      println(i + "," + j + "=" + lon + "," + lat + "=" + elev);
      ret[i][j] = elev;
    }
  }
  return ret;
}

float[][] getElevMap(int wid, int hig){
  float startLon = 128.795837;
  float startLat = 45.090774;
  float endLon = 147.077087;
  float endLat = 32.028794;
  float[][] ret = new float[wid][hig];
  for(int i = 0; i < wid; i++){
    for(int j = 0; j < hig; j++){
      float lon = startLon + ((endLon-startLon)*i)/wid;
      float lat = startLat + ((endLat-startLat)*j)/hig;
      float elev = getElevation(lon, lat);
      delay(10);
      println(i + "," + j + "=" + lon + "," + lat + "=" + elev);
      ret[i][j] = elev;
    }
  }
  return ret;
}

PImage generateImg(float[][] input){
  PImage ret = loadImage("000.png");
  int wid = input.length;
  int hig = input[0].length;
  ret.resize(wid, hig);
  float[] maxMin = maxMin(input);
  
  color newCol = color(0,0,0);
  for(int i = 0; i < wid; i++){
    for(int j = 0; j < hig; j++){
      if(input[i][j]<0) newCol = color(0,0,255);
      else newCol = color(input[i][j]*255/(maxMin[1]-maxMin[0])-maxMin[0]);
      ret.pixels[j*wid + i] = newCol;
    }
  }
  return ret;
  
}

float[] maxMin(float[][] input){
  float[] num = new float[2];
  num[0]=num[1]=input[0][0];
  for(int i=0; i<input.length; i++){
    for(int j=0; j<input[0].length; j++){
      if(input[i][j]<num[0])num[0]=input[i][j];
      if(input[i][j]>num[1])num[1]=input[i][j];
    }
  }
  return num;
}