static final int MARGIN    = 0;
static final int DEVIATION = 1;
static final int HEIGHT    = 2;
static final int TOTAL     = 3;

class Optimizer {
  ArrayList<Candidate> permList;

  Optimizer(Shelf frame, Tray loads) {
    permList = new ArrayList<Candidate>();
    for (Tray perm : permutationList(loads)) {
      this.permList.add(storing(frame, perm));
    }
    this.setEval(TOTAL);
  }
  
  void setEval(int MODE) {
    int I = this.permList.size();
    for (int i = 0; i < I; i++) {
      this.permList.get(i).setEval(MODE);
    }
    this.sort();
  }
  
  void sort() {
    Collections.sort(this.permList, new CandidateComparator());
  }
}