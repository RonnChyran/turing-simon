/*
 #This header is valid YAML 1.2 and can be parsed as such
 File: "simon.t"
 Author: "Ronny Chan"
 Class: ICS2O1
 Date: "7 January 2015"
 Purpose: >
      Simulate the 'Simon' memory game.
 Input:
     Start Screen:
	  - "Number of buttons to use"
	  - "Konami 'cheat code'"
     Game:
	  - "Each 'Simon' Button is clickable"
     Output:
	  - "A sequence of colours will flash that the player should repeat"
	  - "Either a Win or a Fail state depending on whether the player has completed the (by default) 31 turns needed"
 Process:
     Start Screen:
	  - "Draw the start screen"
	  - "Load and display the high score"
	  - "Play intro music"
	  - "Listen for keypresses for either numbers 1-4 to set number of buttons, or the Konami Code (Up-Up-Down-Down-Left-Right-Left-Right-B-A) for cheat (instant win)"
	  - "Listen for click to proceed to game screen"
     Game:
	  - "Append a number (1-4 by default) to a sequence"
	  - "Parse each number in the sequence and display the corresponding image that has that button lit up"
	  - "Wait for user to repeat the displayed sequence"
	  - "Determine if correct button is pressed, if so, increment score by 1"
	  - "Determine if the user has made a mistake by getting the colour clicked, if so, jump to fail state"
	  - "Increment score by 2 if the user passes the turn"
	  - "If 31 (by default) iterations have passed jump to win state"
     Win/Fail State:
	  - "Display wipe-out animation"
	  - "Display either the win or fail state picture"
	  - "Display the user's final score"
	  - "Play a victory or failure tune"
	  - "Save the score if it's a high score"
	  - "Either repeat or quit game"
 Assets: #This program will not run properly without the proper assets
     textures:
	  'base.gif': "The image of all simon buttons unlit"
	  'blue.gif': "The image of the blue simon button lit"
	  'green.gif': "The image of the green simon button lit"
	  'red.gif': "The image of the red simon button lit"
	  'start.gif': "The start screen image"
	  'win.gif': "The image displayed in winstate"
	  'lose.gif': "The image displayed in failstate"
     sound:
	  'beep.wav': "Played when a simon button is lit up"
	  'fail.wav': "Played when the player loses"
	  'win.mp3': "Played when the player wins"
	  'intro.mp3': "Played in the main menu"
 License: "All code is licensed under the MIT License, and all textures are under CC0 1.0 Universal License. Sound assets are copyright of their respective owners"
 */


/**
 * Represents a readable/writable file that stores a single line of text
 */
class TextFile
    import File
    export ctorTextFile, writeFile, readFile
    var fileName : string
    /*
     * Write to the text file
     * @param _input The text to write to the file
     */
    procedure writeFile (_input : string)
	var fileNumber : int
	open : fileNumber, fileName, write
	write : fileNumber, _input
	close : fileNumber
    end writeFile

    /*
     * Read the contents of the text file
     * @returns The contents of the file as a string
     */
    function readFile : string
	var fileContents : string := ""
	var fileNumber : int
	open : fileNumber, fileName, read
	read : fileNumber, fileContents
	close : fileNumber
	result fileContents
    end readFile

    /*
     * TextFile constructor
     * @param _fileName The filename of the file
     */
    procedure ctorTextFile (_fileName : string)
	fileName := _fileName
	if not File.Exists (fileName) then
	    writeFile ("0")
	end if
    end ctorTextFile
end TextFile

View.Set ("graphics:720;800,nobuttonbar,position:centre,centre,offscreenonly,title:Simon Says!")

/**
 * If true program will terminate after the round is over
 */
var bTerminateProgram : boolean := false

/**
 * The current turn number
 */
var iTurnNumber : int := 0
/**
 * The current score number
 */
var iScoreNumber : int := 0


var startScreen, failScreen, winScreen : int

/**
 * The start screen card
 */
startScreen := Pic.FileNew ("assets/textures/start.gif")

/**
 * The fail end-state card
 */
failScreen := Pic.FileNew ("assets/textures/lose.gif")

/**
 * The win end-state card
 */
winScreen := Pic.FileNew ("assets/textures/win.gif")


var arrSimon : array 1 .. 5 of int

/**
 * The green-lit simon state
 */
arrSimon (1) := Pic.FileNew ("assets/textures/green.gif")

/**
 * The red-lit simon state
 */
arrSimon (2) := Pic.FileNew ("assets/textures/red.gif")

/**
 * The blue-lit simon state
 */
arrSimon (3) := Pic.FileNew ("assets/textures/blue.gif")

/**
 * The yellow-lit simon state
 */
arrSimon (4) := Pic.FileNew ("assets/textures/yellow.gif")

/**
 * The unlit simon state
 */
arrSimon (5) := Pic.FileNew ("assets/textures/base.gif")


/**
 * 24pt Segoe UI Bold Font
 */
var font_segoeBold : int := Font.New ("Segoe UI Bold:24")

/**
 * 24pt Segoe UI Font
 */
var font_segoe : int := Font.New ("Segoe UI:24")

/**
 * 24pt Impact Font
 */
var font_impact : int := Font.New ("Impact:24")

/**
 * Number of simon buttons to use
 */
var buttonCount : int := 4

/**
 * File to store high score
 */
var highScoreFile : pointer to TextFile

/**
 * The color code for the lit green simon button
 */
const LIT_GREEN := 10

/**
 * The color code for the lit red simon button
 */
const LIT_RED := 12

/**
 * The color code for the lit blue simon button
 */
const LIT_BLUE := 11

/**
 * The color code for the lit yellow simon button
 */
const LIT_YELLOW := 14


/**
 * The color code for the unlit green simon button
 */
const UNLIT_GREEN := 215

/**
 * The color code for the unlit red simon button
 */
const UNLIT_RED := 112

/**
 * The color code for the unlit blue simon button
 */
const UNLIT_BLUE := 151

/**
 * The color code for the unlit yellow simon button
 */
const UNLIT_YELLOW := 115

/**
 * The array index for the lit green simon button
 */
const BTN_GREEN := 1

/**
 * The array index for the lit red simon button
 */
const BTN_RED := 2

/**
 * The array index for the lit blue simon button
 */
const BTN_BLUE := 3

/**
 * The array index for the lit yellow simon button
 */
const BTN_YELLOW := 4

/**
 * The array index for the all buttons unlit
 */
const BTN_UNLIT := 5

/**
 * The number of rounds required to pass before a win end-state is declared
 */
const ROUND_LIMIT := 31

/**
 * The Y value to render the score number
 * @see drawCenterScore
 */
const SCORE_RENDER_Y := 380

/**
 * The X value to render the score number
 * @see drawCenterScore
 */
const SCORE_RENDER_X := 300

/**
 * The Y value to render the turn number
 * @see drawCenterScore
 */
const TURN_RENDER_Y := 300

/**
 * The X value to render the turn number
 * @see drawCenterScore
 */
const TURN_RENDER_X := 310

/**
 * The filename to the beep sound effect
 */
const SOUND_BEEP := "assets/sound/beep.wav"

/**
 * The filename to the win sound effect
 */
const SOUND_WIN := "assets/sound/win.mp3"

/**
 * The filename to the fail sound effect
 */
const SOUND_FAIL := "assets/sound/fail.wav"

/**
 * The filename to the introductory sound effect
 */
const SOUND_INTRO := "assets/sound/intro.mp3"

/**
 * Internationlization string for loading message
 */
const I18N_LOADING := "loading.."

/**
 * Internationlization string for Simon's turn
 */
const I18N_SIMON_TURN := "Simon's Turn"

/**
 * Internationlization string for Player's turn
 */
const I18N_YOUR_TURN := "Your Turn"

/**
 * Internationlization string for score indication prefix
 */
const I18N_SCORE := "score: "

/**
 * Internationlization string for turn indication prefix
 */
const I18N_TURN := "turn: "

/**
 * High score file filename
 */
const HIGH_SCORE_FILENAME := ".simon"

/**
 * Play a music file asynchronously
 * @param fileName The filename of the music file
 */
process playMusicAsync (fileName : string)
    Music.PlayFile (fileName)
end playMusicAsync

/**
 * Gets the unlit color value for a given button index
 * @param btnNumber The button index to get the unlit color for
 * @returns The turing color code for the unlit color of a certain button
 */
function getUnlitColor (btnNumber : int) : int
    case btnNumber of
	label BTN_GREEN :
	    result UNLIT_GREEN
	label BTN_RED :
	    result UNLIT_RED
	label BTN_BLUE :
	    result UNLIT_BLUE
	label BTN_YELLOW :
	    result UNLIT_YELLOW
    end case
    result black
end getUnlitColor

/**
 * Gets the lit color value for a given button index
 * @param btnNumber The button index to get the lit color for
 * @returns The turing color code for the lit color of a certain button
 */
function getLitColor (btnNumber : int) : int
    case btnNumber of
	label BTN_GREEN :
	    result LIT_GREEN
	label BTN_RED :
	    result LIT_RED
	label BTN_BLUE :
	    result LIT_BLUE
	label BTN_YELLOW :
	    result LIT_YELLOW
    end case
    result black
end getLitColor

/**
 * Gets the button index given a color code
 * Returns unlit index if invalid color is given
 * @param btnColor The color of a button
 * @returns The corresponding button index for that color
 */
function getBtnFromUnlit (btnColor : int) : int
    case btnColor of
	label UNLIT_GREEN :
	    result BTN_GREEN
	label UNLIT_RED :
	    result BTN_RED
	label UNLIT_BLUE :
	    result BTN_BLUE
	label UNLIT_YELLOW :
	    result BTN_YELLOW
    end case
    result BTN_UNLIT
end getBtnFromUnlit

/**
 * Appends a random button to the existing sequence
 * @param var sqeuence The sequence to append
 */
procedure randAppendSequence (var sequence : string)
    sequence += intstr (Rand.Int (1, buttonCount))
end randAppendSequence

/**
 * Draws the current score and turn number in the center of the Simon buttons
 * @param score The current score number
 * @param turn The current turn number
 */
procedure drawCenterScore (score : int, turn : int)
    Font.Draw (I18N_SCORE + intstr (score), SCORE_RENDER_X, SCORE_RENDER_Y, font_segoe, white)
    Font.Draw (I18N_TURN + intstr (turn), TURN_RENDER_X, TURN_RENDER_Y, font_segoe, white)
    View.Update
end drawCenterScore

/**
 * Render a certain lit color on the screen
 * @param btnNumber The button index to render lit
 */
procedure renderLitColor (btnNumber : int)
    Pic.Draw (arrSimon (btnNumber), 5, 0, picCopy)
    drawCenterScore (iScoreNumber, iTurnNumber)
    View.Update
end renderLitColor

/**
 * Fills the screen with a certain color
 * @param bgColor the color to fill the screen with
 */
procedure drawBackground (bgColor : int)
    drawfillbox (0, 0, maxx, maxy, bgColor)
    View.Update
end drawBackground

/**
 * Render a blank (no buttons lit) Simon state
 */
procedure renderBlank
    renderLitColor (BTN_UNLIT)
end renderBlank

/**
 * Draw the current status of the game in the upper left
 * @param message The message to draw
 */
procedure drawStatus (message : string)
    Font.Draw (message, 10, maxy - 50, font_segoe, white)
    View.Update
end drawStatus

/**
 * Render a black screen to buffer any mouseclicks
 * Used to prevent any mouse-clicks during initialziation from being registered as
 * button presses before the program is ready to accept them
 */
procedure renderBuffer
    drawBackground (black)
    drawStatus (I18N_LOADING)
    delay (1000)
    cls
    drawBackground (black)
end renderBuffer

/**
 * Render a certain sequence of lit buttons
 * @param sequence The sequence to render
 * @see generateSequence
 * @see randAppendSequence
 */
procedure renderSequence (sequence : string)
    delay (500)
    for i : 1 .. length (sequence)
	renderLitColor (strint (sequence (i)))
	Music.PlayFile (SOUND_BEEP)
	delay (1000)
	renderBlank
	delay (500)
    end for
end renderSequence
/**
 * Wait for user indication to either repeat game or quit
 */
procedure continueOrExit
    var chars : array char of boolean
    loop
	var x, y, buttonDown : int
	Mouse.Where (x, y, buttonDown)         %wait for player to press button
	Input.KeyDown (chars) /*Check if a key has been pressed*/
	if chars ('q') or chars (KEY_ESC) then
	    Window.Hide (defWinId)
	    bTerminateProgram := true
	    exit
	end if
	exit when buttonDown = 1
    end loop
end continueOrExit

/**
 * Saves the high score to file
 */
procedure saveHighScore
    if (strint (highScoreFile -> readFile) < iScoreNumber) then
	highScoreFile -> writeFile (intstr (iScoreNumber))
    end if
end saveHighScore

/**
 * This function is called when the player loses
 * Draws the lose endstate card and shows their final score
 */
procedure failState
    for i : 0 .. 360
	Draw.FillArc (maxx div 2, maxy div 2, maxx, maxy, 0, i, white)
	delay (5)
	View.Update
    end for
    Pic.Draw (failScreen, 0, 0, picCopy)
    Font.Draw (intstr (iScoreNumber), maxx - 300, 45, font_segoeBold, white)
    Font.Draw ("turn :"+intstr (iTurnNumber), maxx - 200, 45, font_segoeBold, white)
    View.Update
end failState

/**
 * This function is called when the player wins. ROUND_LIMIT turns are required to win the game
 * Draws the win endstate card and shows their final score
 */
procedure winState
    for i : 0 .. 360
	Draw.FillArc (maxx div 2, maxy div 2, maxx, maxy, 0, i, red)
	delay (5)
	View.Update
    end for
    Pic.Draw (winScreen, 0, 0, picCopy)
    Font.Draw (intstr (iScoreNumber), maxx - 300, 45, font_segoeBold, white)
    Font.Draw ("turn :"+intstr (iTurnNumber), maxx - 200, 45, font_segoeBold, white)

    View.Update
    fork playMusicAsync (SOUND_WIN)
end winState

/**
 * The main game loop
 */
procedure mainLoop
    iTurnNumber := 0 %Reset turn number
    iScoreNumber := 0 %Reset score number
    var x, y, buttonNumber, buttonUpDown : int %Mouse.ButtonWait vars
    var failStateTrue : boolean := false %this is toggled to true if the player loses
    var correctButtonPresses : int := 0 %number of correct button presses
    var sequence : string := "" %the simon button sequence. This is appended to every turn
    renderBuffer %Render a mouse-queue clearing buffer
    for r : 1 .. ROUND_LIMIT
	iTurnNumber := r %set the current turn number to iteration number
	randAppendSequence (sequence) %append a random button to the sequence
	drawBackground (black)
	renderBlank
	drawStatus (I18N_SIMON_TURN)
	renderSequence (sequence)
	drawBackground (black)
	renderBlank
	drawStatus (I18N_YOUR_TURN)

	%Wait for inputs for the length of the sequence
	%If the input doesn't match the color in that index of the sequence, it will toggle failstate to true
	for i : 1 .. length (sequence)
	    var selectedColor : int
	    selectedColor := black
	    loop
		var buttonDown : int
		Mouse.Where (x, y, buttonDown) %wait for player to press button
		selectedColor := whatdotcolor (x, y) %get pressed color
		exit when buttonDown = 1 and selectedColor not= black and selectedColor not= white and (selectedColor = UNLIT_GREEN or selectedColor = UNLIT_RED or selectedColor = UNLIT_YELLOW or
		    selectedColor = UNLIT_BLUE) %whitelist colors to prevent clicking outside of screen
	    end loop
	    fork playMusicAsync (SOUND_BEEP) %Play a sound to indicate button pressed
	    loop
		var buttonUp : int
		Mouse.Where (x, y, buttonUp)
		renderLitColor (getBtnFromUnlit (selectedColor)) %Render the color as lit if the player presses the button
		exit when buttonUp = 0
	    end loop
	    if getBtnFromUnlit (selectedColor) not= strint (sequence (i)) then %If the selected color is not the correct button index toggle failstate
		failStateTrue := true
		exit
	    end if
	    iScoreNumber += 1 %Correct button press
	    renderBlank
	end for
	iScoreNumber += 2 %perfect turn bonus 
	if failStateTrue then
	    fork playMusicAsync (SOUND_FAIL)
	    exit %If failstate, terminate loop and jump to procedure end
	end if
    end for
    if failStateTrue then
	failState %jump to failState if player failed
    else
	winState %jump to winState if player managed finish ROUND_LIMIT iterations
    end if
    saveHighScore %save highscore
    continueOrExit %wait for user input to repeat game or exit
end mainLoop


/**
 * Start-screen loop
 * Waits for button press before jumping to {@link #mainLoop}
 */
procedure entryLoop

    var x, y, button, buttonupdown : int %Mouse.ButtonWait variables
    var chars : array char of boolean

    /* Represent the Konami Code (Up Up Down Down Left Right Left Right B A) as an array of chars */
    var konamiCode : array 1 .. 10 of char
    konamiCode (1) := KEY_UP_ARROW
    konamiCode (2) := KEY_UP_ARROW
    konamiCode (3) := KEY_DOWN_ARROW
    konamiCode (4) := KEY_DOWN_ARROW
    konamiCode (5) := KEY_LEFT_ARROW
    konamiCode (6) := KEY_LEFT_ARROW
    konamiCode (7) := KEY_RIGHT_ARROW
    konamiCode (8) := KEY_RIGHT_ARROW
    konamiCode (9) := 'b'
    konamiCode (10) := 'a'
    var konamiCodeCounter : int := 1


    Pic.Draw (startScreen, 0, 0, picCopy) %Draw the start state card
    if (highScoreFile -> readFile not= "") then
	Font.Draw ("high score: " + highScoreFile -> readFile, 0, maxy - 25, font_segoe, black)
    end if
    View.Update
    Music.PlayFileReturn (SOUND_INTRO)
    loop
	if konamiCodeCounter = 11 then     /*If the user has pressed all the previous keys activate win*/
	    iScoreNumber := 1337     /*1337haxx0rz*/
	    winState
	    continueOrExit
	    exit
	else
	    Input.KeyDown (chars)     /*Check if a key has been pressed*/
	    if chars (konamiCode (konamiCodeCounter)) then
		konamiCodeCounter += 1     /*If part of the Konami code has been pressed go to the next key*/
	    end if
	     /*Determine number of buttons to use*/
	    if chars ('1') then
		buttonCount := 1
	    end if
	    if chars ('2') then
		buttonCount := 2
	    end if
	    if chars ('3') then
		buttonCount := 3
	    end if
	    if chars ('4') then
		buttonCount := 4
	    end if
	end if


	Mouse.Where (x, y, button)
	if button = 1 then
	    loop
		exit when not Mouse.ButtonMoved ("up")
		Mouse.ButtonWait ("up", x, y, button, buttonupdown)
	    end loop
	    cls
	    Music.PlayFileStop
	    mainLoop
	    exit
	end if
    end loop
end entryLoop

new highScoreFile %initialize highscore data file
highScoreFile -> ctorTextFile (HIGH_SCORE_FILENAME) %call TextFile constructor

loop
    entryLoop     %Initial call into entry loop
    exit when bTerminateProgram     %Quit when quit flag is triggered
end loop
