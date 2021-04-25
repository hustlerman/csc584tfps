import java.util.Scanner;

class GridCell {
  int x;
  int y;
  boolean traversable;
  boolean cleared;
  
  GridCell(int x, int y, boolean traversable) {
    this.x = x;
    this.y = y;
    this.traversable = traversable;
    this.cleared = false;
  }
}

boolean[][] generateGridFromFile() {
    String[] lines = loadStrings("gamemap.txt");
    
    boolean[][] map = new boolean[lines.length][lines[0].length()];
    
    for(int i = 0; i < lines.length; i++) {
      for(int j = 0; j < lines[i].length(); j++) {
        map[i][j] = lines[i].charAt(j) == 'o';
      }
    }
    
    return map;
}
