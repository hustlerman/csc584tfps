import java.util.Scanner;

class GridCell {
  int x;
  int y;
  boolean traversable;
  boolean cleared;
  int exposure;
  
  GridCell(int x, int y, boolean traversable, boolean map[][]) {
    this.x = x;
    this.y = y;
    this.traversable = traversable;
    this.cleared = false;
    this.exposure = 0;
    
    if(y < map.length - 1 && map[y + 1][x])
      exposure++;
    if(y > 1 && map[y - 1][x])
      exposure++;
    if(x > 1 && map[y][x - 1])
      exposure++;
    if(x < map[0].length - 1 && map[y][x + 1])
      exposure++; 
    if(x > 1 && y < map.length - 1 && map[y + 1][x - 1])
      exposure++;
    if(x < map[0].length - 1&& y < map.length - 1 && map[y + 1][x + 1])
      exposure++;
    if(x > 1 && y > 1 && map[y - 1][x - 1])
      exposure++;
    if(x < map[0].length - 1 && y > 1 &&map[y - 1][x + 1])
      exposure++;
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
