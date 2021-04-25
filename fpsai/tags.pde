class PriorityTag<T> implements Comparable<PriorityTag<T>> {
  Node<T> node;
  
  float value;
  Edge<T> edge;
  
  PriorityTag(Node<T> node, float value, Edge<T> edge) {
    this.node = node;
    this.value = value;
    this.edge = edge;
  }
  
  int compareTo(PriorityTag<T> o) {
    if(this.value < o.value)
      return -1;
    else if(this.value > o.value)
      return 1;
    else
      return 0;
  }
}

class HeuristicPriorityTag<T> extends PriorityTag<T> {
  float heuristicValue;
  
  HeuristicPriorityTag(Node<T> node, float value, Edge<T> edge, float heuristicValue) {
    super(node, value,edge);
    this.heuristicValue = heuristicValue;
  }
  
  @Override
  int compareTo(PriorityTag<T> o) {
    if(this.value + this.heuristicValue < o.value + ((HeuristicPriorityTag<T>) o).heuristicValue)
      return -1;
    else if(this.value + this.heuristicValue > o.value + ((HeuristicPriorityTag<T>) o).heuristicValue)
      return 1;
    else
      return 0;
  }
}
