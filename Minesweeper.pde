import de.bezier.guido.*;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public final static int NUM_ROWS = 30;
public final static int NUM_COLS = 30;

public int bombNum = 150;
public int numFlags = bombNum;
public boolean hasFlags = true;

public int xWidth = 600;
public int yHeight = 600;
public boolean isLost = false;
 
public boolean gameOver = false;
public int timed = 0;
public int seconds = 0;
public boolean mouseStart = false;

void setup () {
    frameRate(60);

    size(600, 650);
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
    background(255);
    if (!gameOver) {
        textSize(30);
        color(255);
        text("Bombs Left: " + numFlags, 150, 625);

        if (mouseStart == true) {
            seconds ++;
            if (seconds >= 60) {
                seconds = 0;
                timed ++;
            }
        }
        text("Time: " + timed, 450, 625);

        textSize(10);

    } else {
        if (!isWon()) {
            textSize(30);
            color(255);
            text("GAMEOVER  YOU LOSE", 300, 625);
            textSize(10);
        } else {
            textSize(30);
            color(255);
            text("WINNER!!!!    Time Taken: " + timed, 300, 625);
            textSize(10);
        }
    }

    if(isWon()) {
        gameOver = true;
        mouseStart = false;
        displayWinningMessage();
    } else if (isLost) {
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

    for (int c = 12; c < losingMessage.length() + 12; c ++) {
        buttons[(int)(NUM_ROWS / 2)][c].setLabel(losingMessage.substring(c - 12, c - 11));
    }

    
}


public void displayWinningMessage() {
    String winningMessage = "YOU WIN!";

    for (int c = 11; c < winningMessage.length() + 11; c ++) {
        buttons[(int)(NUM_ROWS / 2)][c].setLabel(winningMessage.substring(c - 11, c - 10));
    }
}

public void keyPressed(){
    if (key == 32) {
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
              numFlags = bombNum;
              mouseStart = false;
              seconds = 0;
              timed = 0;
            }
        }
        setBombs(); 
    }
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
        mouseStart = true;

        if (mouseButton == LEFT && label.equals("") && !marked) {
            clicked = true;
        }
        if (mouseButton == RIGHT && label.equals("") && !clicked) {
            if (isMarked()) {
                numFlags ++;
            } else {
                numFlags --;
            }
            marked = !marked;
            clicked = false;
        } else if (bombs.contains(this)) {
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



