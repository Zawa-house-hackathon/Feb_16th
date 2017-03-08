ArrayList<Tray> permutationList(Tray _input) {
  Tray            temp, child;
  int             arg;
  ArrayList<Tray> parent    = new ArrayList();
  int             times     = fact(_input.size());
  int []          factArray = new int [_input.size()-1];
  for (int i = 0; i < factArray.length; i++) factArray[i] = fact(factArray.length-i);

  for (int i = 0; i < times; i++) {
    temp  = new Tray(_input);
    child = new Tray();
    for (int j = 0; j < factArray.length; j++) {
      arg = (j==0 ? i : i%factArray[j-1]) / factArray[j];
      child.add(temp.get(arg));
      temp.remove(arg);
    }
    child.add(temp.get(0));
    parent.add(child);
  }
  return parent;
}

int fact(int num) {
  if (num <= 1) return 1;
  else return num * fact(num - 1);
}