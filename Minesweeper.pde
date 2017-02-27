import de.bezier.guido.*;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;

public int bombNum = 75;

public int xWidth = 600;
public int yHeight = 600;
public boolean isLost = false;

public boolean gameOver = false;

void setup () {
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int rows = 0; rows < NUM_ROWS; rows ++) {
        for (int cols = 0; cols < NUM_COLS; cols ++) {
            buttons[rows][cols] = new MSButton(rows, cols);
        }
    }
    
    setBombs();
}


public void setBombs() {
    while (bombs.size() < bombNum) {
        int row = (int) (Math.random() * NUM_ROWS);
        int col = (int) (Math.random() * NUM_COLS);

        if (!bombs.contains(buttons[row][col])) {
            bombs.add(buttons[row][col]);
        }
    }
}


public void draw () {
    background( 0 );
    if(isWon())
        gameOver = true;
        displayWinningMessage();
    else if (isLost == true) {
        gameOver = true;
        displayLosingMessage();
    }
}


public boolean isWon() {
    for (int r = 0; r < NUM_ROWS; r ++) {
        for (int c = 0; c < NUM_COLS; c ++) {
            if (!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked()) {
                return false;
            }
        }
    }
    return true;
}


public void displayLosingMessage() {
    String losingMessage = "YOU LOSE";

    for (int r = 0; r < NUM_ROWS; r ++) {
        for (int c = 0; c < NUM_COLS; c ++) {
            if (bombs.contains(buttons[r][c])) {
                buttons[r][c].mousePressed();
            }
        }
    } 

    for (int c = 5; c < losingMessage.length() + 5; c ++) {
        buttons[(int)(NUM_ROWS / 2)][c].setLabel(losingMessage.substring(c - 5, c - 4));
    }

    
}


public void displayWinningMessage() {
    String winningMessage = "YOU WIN!";

    for (int c = 6; c < winningMessage.length() + 6; c ++) {
        buttons[9][c].setLabel(winningMessage.substring(c - 6, c - 5));
    }
}

public void keyPressed(){
    for(int r = 0; r < NUM_ROWS; r++)
    {
      for(int c = 0; c < NUM_COLS; c++)
      {
          isLost = false;
          gameOver = false;
          bombs.remove(buttons[r][c]);
          buttons[r][c].setLabel("");
          buttons[r][c].marked = false;
          buttons[r][c].clicked = false;
        }
    }
    setBombs(); 
}


public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc ) {
        width = xWidth/NUM_COLS;
        height = yHeight/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    public boolean isMarked() {
        return marked;
    }

    public boolean isClicked() {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () {
        if (mouseButton == LEFT && label.equals("") && !marked) {
            clicked = true;
        }
        if (mouseButton == RIGHT && label.equals("") && !clicked) {
            marked = !marked;
            clicked = false;
        } else if (bombs.contains(this)) {
            //displayLosingMessage();
            isLost = true;
        } else if (countBombs(r, c) > 0) {
            setLabel("" + countBombs(r, c));
        } else {
            if (isValid(r, c - 1) && !buttons[r][c - 1].clicked) {
                buttons[r][c - 1].mousePressed();
            }
            if (isValid(r, c + 1) && !buttons[r][c + 1].clicked) {
                buttons[r][c + 1].mousePressed();
            }
            if (isValid(r - 1, c) && !buttons[r - 1][c].clicked) {
                buttons[r - 1][c].mousePressed();
            }
            if (isValid(r + 1, c) && !buttons[r + 1][c].clicked) {
                buttons[r + 1][c].mousePressed();
            }
            if (isValid(r + 1, c - 1) && !buttons[r + 1][c - 1].clicked) {
                buttons[r + 1][c - 1].mousePressed();
            }
            if (isValid(r - 1, c + 1) && !buttons[r - 1][c + 1].clicked) {
                buttons[r - 1][c + 1].mousePressed();
            }
            if (isValid(r - 1, c - 1) && !buttons[r - 1][c - 1].clicked) {
                buttons[r - 1][c - 1].mousePressed();
            }
            if (isValid(r + 1, c + 1) && !buttons[r + 1][c + 1].clicked) {
                buttons[r + 1][c + 1].mousePressed();
            }
        }
    }


    public void draw () {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }

    public void setLabel(String newLabel) {
        label = newLabel;
    }

    public boolean isValid(int r, int c) {
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
            return true;
        }
        return false;
    }

    public int countBombs(int row, int col) {
        int numBombs = 0;
        for(int rr = -1; rr < 2; rr++){
              for(int cc = -1; cc < 2; cc++){
                  if(isValid(row+rr,col+cc) && bombs.contains(buttons[row+rr][col+cc]))
                      numBombs++;
              }
          }

        return numBombs;
    }

}



