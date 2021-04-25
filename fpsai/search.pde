import java.util.PriorityQueue;
import java.util.HashSet;

abstract class GraphSearch<T> {
   Node<T> goal;
   HashMap<Node<T>,PriorityTag<T>> tags;
   
   PriorityQueue<PriorityTag<T>> open;
   HashSet<Node<T>> closed;
   
  abstract void reset(Node<T> start, Node<T> goal);
  abstract void update();
  int maxOpen;
  
  List<Edge<T>> shortestPath() {
    if(closed.contains(goal)) {
      ArrayList<Edge<T>> path = new ArrayList<Edge<T>>();
      
      PriorityTag<T> tag = tags.get(goal);
      
      while(null != tag.edge) {
        path.add(tag.edge);
        tag = tags.get(tag.edge.start);
      }
      
      return path;
    } else {
      return null;
    }
  }
  
  Collection<Node<T>> openSet() {
    if(null != open) {
      ArrayList<Node<T>> list = new ArrayList<Node<T>>();
    
      for(PriorityTag<T> tag : open)
        list.add(tag.node);
    
      return list;
    } else {
      return null;
    }
  }
  
  Collection<Node<T>> closedSet() {
    return closed; 
  }
  
  
}

class Dijkstra<T> extends GraphSearch<T> {
  
   void reset(Node<T> start, Node<T> goal) {
     this.goal = goal;
     
     this.tags = new HashMap<Node<T>,PriorityTag<T>>();
     
     this.open = new PriorityQueue<PriorityTag<T>>();
     this.closed = new HashSet<Node<T>>();
     
     PriorityTag<T> tag = new PriorityTag<T>(start, 0, null);
     tags.put(start,tag);
     open.add(tag);
     maxOpen = 1;
   }
   
   void update() {
     // Check if there's anything in the open set
     if(!open.isEmpty() || closed.contains(goal)) {
       maxOpen = max(maxOpen, open.size());
       // Choose the most promising node from the frontier
       PriorityTag<T> tag = open.poll();

       // If the current tag is the goal, terminate; you found the node
       if(tag.node == goal) {
          open.clear();
          closed.add(goal);
          return; 
       }
       
       // Iterate over each successor
       for(Edge<T> edge : tag.node.outgoing) {
         float cfs = tag.value + edge.weight;
         PriorityTag<T> n = tags.get(edge.end);
         // If the tag is null, then we haven't encountered it before
         if(n == null) {
           PriorityTag<T> next_tag = new PriorityTag<T>(edge.end, cfs, edge);
           tags.put(edge.end, next_tag);
           open.add(next_tag);
         } else if(open.contains(n) && cfs < n.value) { // Otherwise, check to see if this path was more optimal than the one on the frontier
           open.remove(n);
           n.value = cfs;
           n.edge = edge;
           open.add(n);
         }
       }
       closed.add(tag.node);
     }
   }
}

class aStar<T> extends GraphSearch<T> {
  Heuristic<T> heuristic;
  
  aStar(Heuristic<T> heuristic) {
     this.heuristic = heuristic;
  }
  
  void reset(Node<T> start, Node<T> goal) {
    this.goal = goal;
    
    tags = new HashMap<Node<T>,PriorityTag<T>>();
  
    open = new PriorityQueue<PriorityTag<T>>();
    closed = new HashSet<Node<T>>();
    
    PriorityTag<T> tag = new HeuristicPriorityTag<T>(start, 0 , null, heuristic.value(start.value, goal.value));
    tags.put(start, tag);
    open.add(tag);
    maxOpen = 1;
  }
  
  void update() {
     // Check if there's anything in the open set
     if(!open.isEmpty()) {
       maxOpen = max(maxOpen, open.size());
  
       // Choose the most promising node from the frontier
       PriorityTag<T> tag = open.poll();
       // If the current tag is the goal, set the lowest cost path
       if(tag.node == goal) {
          open.clear();
          closed.add(goal);
          return; 
       }
       
       // Iterate over each successor
       for(Edge<T> edge : tag.node.outgoing) {
         float cfs = tag.value + edge.weight;
         float h = heuristic.value(edge.end.value, goal.value);
         HeuristicPriorityTag<T> n = (HeuristicPriorityTag<T>)tags.get(edge.end);
         // If the tag is null, then we haven't encountered it before
         if(n == null) {
           HeuristicPriorityTag<T> next_tag = new HeuristicPriorityTag<T>(edge.end, cfs, edge, h);
           tags.put(edge.end, next_tag);
           open.add(next_tag);
         } else if(open.contains(n) && cfs < n.value) { // Otherwise, check to see if this path was more optimal than the one on the frontier
           open.remove(n);
           n.value = cfs;
           n.edge = edge;
           n.heuristicValue = h;
           open.add(n);
         }   
       }
       closed.add(tag.node);
     }
   }
  
}

class aStarTactical<T> extends GraphSearch<T> {
  Heuristic<T> heuristic;
  
  aStarTactical(Heuristic<T> heuristic) {
     this.heuristic = heuristic;
  }
  
  void reset(Node<T> start, Node<T> goal) {
    this.goal = goal;
    
    tags = new HashMap<Node<T>,PriorityTag<T>>();
  
    open = new PriorityQueue<PriorityTag<T>>();
    closed = new HashSet<Node<T>>();
    
    PriorityTag<T> tag = new HeuristicPriorityTag<T>(start, 0 , null, heuristic.value(start.value, goal.value));
    tags.put(start, tag);
    open.add(tag);
    maxOpen = 1;
  }
  
  void update() {
     // Check if there's anything in the open set
     if(!open.isEmpty()) {
       maxOpen = max(maxOpen, open.size());
  
       // Choose the most promising node from the frontier
       PriorityTag<T> tag = open.poll();
       // If the current tag is the goal, set the lowest cost path
       if(tag.node == goal) {
          open.clear();
          closed.add(goal);
          return; 
       }
       
       // Iterate over each successor
       for(Edge<T> edge : tag.node.outgoing) {
         float cfs = tag.value + edge.weight + ((GridCell)edge.end.value).exposure * 10;
         float h = heuristic.value(edge.end.value, goal.value);
         HeuristicPriorityTag<T> n = (HeuristicPriorityTag<T>)tags.get(edge.end);
         // If the tag is null, then we haven't encountered it before
         if(n == null) {
           HeuristicPriorityTag<T> next_tag = new HeuristicPriorityTag<T>(edge.end, cfs, edge, h);
           tags.put(edge.end, next_tag);
           open.add(next_tag);
         } else if(open.contains(n) && cfs < n.value) { // Otherwise, check to see if this path was more optimal than the one on the frontier
           open.remove(n);
           n.value = cfs;
           n.edge = edge;
           n.heuristicValue = h;
           open.add(n);
         }   
       }
       closed.add(tag.node);
     }
   }
  
}


class GreedyBestFirst<T> extends GraphSearch<T> {
  Heuristic<T> heuristic; 
  
  GreedyBestFirst(Heuristic<T> heuristic) {
    this.heuristic = heuristic;
  }
  
  void reset(Node<T> start, Node<T> goal) {
    this.goal = goal;
    
    tags = new HashMap<Node<T>,PriorityTag<T>>();
  
    open = new PriorityQueue<PriorityTag<T>>();
    closed = new HashSet<Node<T>>();
    
    PriorityTag<T> tag = new PriorityTag<T>(start, heuristic.value(start.value, goal.value), null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update() {
    if(!tags.containsKey(goal)) {
       PriorityTag<T> tag = open.poll();
       
       if(null != tag && !closed.contains(tag.node)) {
          for(Edge<T> edge : tag.node.outgoing) {
            if(!tags.containsKey(edge.end)) {
              float ctg = heuristic.value(edge.end.value, goal.value);
              PriorityTag<T> next_tag = new PriorityTag<T>(edge.end, ctg, edge);
              
              tags.put(edge.end, next_tag);
              open.add(next_tag);
            }
            
            if(edge.end == goal)
              break;
          }
          
          closed.add(tag.node);
       }
    }
  }
}
