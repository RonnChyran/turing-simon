View.Set ("graphics:720;800,nobuttonbar,position:centre,centre,offscreenonly,title:Simon Says!")

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
 * Generates a sequence of buttons to be lit
 * @param sequenceLength The length of the sequence
 * @returns A sequence with the specified length as string
 */
function generateSequence (sequenceLength : int) : string
    var sequence : string := ""
    for i : 1 .. sequenceLength
	sequence += intstr (Rand.Int (1, 4))
    end for
    result sequence
end generateSequence

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
    sequence += intstr (Rand.Int (1, 4))
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
	play ("A")
	delay (1000)
	renderBlank
	delay (500)
    end for
end renderSequence

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
    View.Update
end failState

/**
 * This function is called when the player wins. RAND_LIMIT turns are required to win the game
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
    View.Update
end winState

/**
 * The main game loop
 */
procedure mainLoop
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
	    play ("B") %Play a sound to indicate button pressed
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
	    iScoreNumber += 1
	    renderBlank
	end for
	if failStateTrue then
	    exit %If failstate, terminate loop and jump to procedure end
	end if
    end for
    if failStateTrue then
	failState %jump to failState if player failed
    else
	winState %jump to winState if player managed finish ROUND_LIMIT iterations
    end if
end mainLoop


/**
* Start-screen loop
* Waits for button press before jumping to {@link #mainLoop}
*/
procedure entryLoop
    var x, y, button, buttonupdown : int %Mouse.ButtonWait variables
    Pic.Draw (startScreen, 0, 0, picCopy) %Draw the start state card
    View.Update
    loop
	Mouse.Where (x, y, button)
	if button = 1 then
	    loop
		exit when not Mouse.ButtonMoved ("down")
		Mouse.ButtonWait ("down", x, y, button, buttonupdown)
	    end loop
	    cls
	    mainLoop
	    exit
	end if
    end loop
end entryLoop

entryLoop %Initial call into entry loop
