class Candidate extends Shelf {
  float evaluate = 0;

  Candidate(Shelf original) {
    super(original);
  }

  float eval(int MODE) {
    float evaluation = 0;
    int size = this.size();
    switch(MODE) {
    case 0:
      for (int i = 0; i < size; i++) {
        evaluation += this.margin(i);
      }
      break;
    case 1:
      for (int i = 0; i < size; i++) {
        evaluation += pow(this.margin(i), 2);
      }
      break;
    case 2:
      for (int i = 0; i < size; i++) {
        evaluation += this.height(i);
      }
      break;
    case 3:
      for (int i = 0; i < size; i++) {
        evaluation += pow(this.margin(i), 2);
        evaluation += this.height(i);
      }
      break;
    default:
      return -1;
    }
    return evaluation;
  }

  void setEval(int MODE) {
    this.evaluate = this.eval(MODE);
  }
}

class CandidateComparator implements Comparator<Candidate> {
  public int compare(Candidate c1, Candidate c2) {
    if (c1.evaluate < c2.evaluate) return -1;
    if (c1.evaluate > c2.evaluate) return 1;
    return 0;
  }
}