import de.bezier.guido.*;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;

public int noBomb;

void setup () {
    size(400, 400);
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

    noBomb = (NUM_ROWS * NUM_COLS) - bombs.size();
}


public void setBombs() {
    while (bombs.size() < 25) {
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
        displayWinningMessage();
}


public boolean isWon() {
    if (noBomb <= 0) {
        return true;
    }
    return false;
}


public void displayLosingMessage() {
    //your code here
}


public void displayWinningMessage() {
    
}


public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc ) {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
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
        noBomb -= 1;
        clicked = true;
        if (keyPressed == true) {
            marked = !marked;
            clicked = false;
        } else if (bombs.contains(this)) {
            displayLosingMessage();
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



