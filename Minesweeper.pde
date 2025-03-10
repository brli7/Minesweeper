
import de.bezier.guido.*;
private final static int NUM_ROWS = 25;
private final static int NUM_COLS = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < buttons.length; i++) {
      for(int e = 0; e < buttons[i].length; e++) {
        buttons[i][e] = new MSButton(i, e);
      }
    }
    
    
    setMines();
}
public void setMines()
{    
    int mineRow = (int)(Math.random()*NUM_ROWS);
    int mineCol = (int)(Math.random()*NUM_COLS);
    while(mines.size() < NUM_ROWS*NUM_COLS/6) {
      if(!(mines.contains(buttons[mineRow][mineCol]))) {
        mines.add(new MSButton(mineRow, mineCol));
        mineRow = (int)(Math.random()*NUM_ROWS);
        mineCol = (int)(Math.random()*NUM_COLS);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int clicked = 0;
    for(int i = 0; i < NUM_ROWS; i++) {
      for(int e = 0; e < NUM_ROWS; e++) {
        if(buttons[i][e].isClicked()){
          clicked++;
        }
      }
    }
    if(clicked == (NUM_ROWS*NUM_COLS)-mines.size()) {
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < mines.size(); i++) {
      if(!mines.get(i).isClicked()) {
        mines.get(i).mousePressed();
      }
    }
    textSize(100);
    fill(100,0,0);
    text("lose", 300,300);
    fill(255,0,0);
    stop();
}
public void displayWinningMessage()
{
    textSize(100);
    fill(0,255,0);
    text("win", 300,300);
    stop();
}
public boolean isValid(int r, int c)
{
    return (r<NUM_ROWS && r >=0) && (c<NUM_COLS && c>=0);
}
public int countMines(int row, int col)
{
    int[][] mineCoords = new int[2][mines.size()];
    for(int i = 0; i < mines.size(); i++) {
      mineCoords[0][i] = mines.get(i).myRow;
      mineCoords[1][i] = mines.get(i).myCol;
    }
    int total = 0;
    for(int i = -1; i < 2; i++) {
      for(int e = -1; e < 2; e++) {
        if(i == 0 && e == 0) {
          e++;
        }        
        if(isValid(row+i,col+e)) {
          for(int b = 0; b < mineCoords[0].length; b++) {
            if(mineCoords[0][b] == row+i && mineCoords[1][b] == col+e) {
              total++;
              break;
            }
          }
        }
      }
    }
    return total;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    
    public boolean isClicked() {
      return clicked;
    }

    // called by manager
    public void mousePressed () 
    {
      clicked = true;
      
        if(mouseButton == RIGHT) {
          flagged = !flagged;
          clicked = false;
        } else if (mines.contains(this)) {
          noLoop();
          displayLosingMessage();
        } else if (countMines(myRow, myCol) > 0) {
          this.setLabel(""+(countMines(myRow, myCol)));
        } else { 
          for(int i = -1; i < 2; i++) {
            for(int e = -1; e < 2; e++) {
              if(isValid(myRow+i, myCol+e) && !buttons[myRow+i][myCol+e].isClicked()) {
                buttons[myRow+i][myCol+e].mousePressed();
              }
            }
          }
          
        } 
    }
    public void draw () 
    {    
        if( clicked && mines.contains(this) ) {
            fill(255,0,0);
            noLoop();
            displayLosingMessage();
        }
        if(isWon()) {
          noLoop();
          displayWinningMessage();
        }
      
      if (flagged)
            fill(0,0,255);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
            
        if( clicked && mines.contains(this) ) {
            fill(255,0,0);
            noLoop();
            displayLosingMessage();
        }
        

        rect(x, y, width, height);
        fill(0);
        textSize(10);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}






