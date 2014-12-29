import GUI
View.Set ("graphics:720;800,nobuttonbar,position:centre,centre,offscreenonly,title:Simon Says!")


var turnNumber : int := 0
var scoreNumber : int := 0

var startScreen, failScreen, winScreen : int
startScreen := Pic.FileNew ("assets/textures/start.gif")
failScreen := Pic.FileNew ("assets/textures/lose.gif")
winScreen := Pic.FileNew ("assets/textures/win.gif")

var arrSimon : array 1 .. 5 of int
arrSimon (1) := Pic.FileNew ("assets/textures/green.gif")
arrSimon (2) := Pic.FileNew ("assets/textures/red.gif")
arrSimon (3) := Pic.FileNew ("assets/textures/blue.gif")
arrSimon (4) := Pic.FileNew ("assets/textures/yellow.gif")
arrSimon (5) := Pic.FileNew ("assets/textures/base.gif")


var segoeBold : int := Font.New ("Segoe UI Bold:24")
var segoe : int := Font.New ("Segoe UI:24")

const LIT_GREEN := 10
const LIT_RED := 12
const LIT_BLUE := 11
const LIT_YELLOW := 14

const UNLIT_GREEN := 215
const UNLIT_RED := 112
const UNLIT_BLUE := 151
const UNLIT_YELLOW := 115

const BTN_GREEN := 1
const BTN_RED := 2
const BTN_BLUE := 3
const BTN_YELLOW := 4
const BTN_UNLIT := 5

const ROUND_LIMIT := 31

const SCORE_RENDER_Y := 380
const SCORE_RENDER_X := 300
const TURN_RENDER_Y := 300
const TURN_RENDER_X := 310

const I18N_LOADING := "loading.."
const I18N_SIMON_TURN := "Simon's Turn"
const I18N_YOUR_TURN := "Your Turn"
const I18N_SCORE := "Score: "
const I18N_TURN := "Turn: "

function generateSequence (sequenceLength : int) : string
    var sequence : string := ""
    for i : 1 .. sequenceLength
	sequence += intstr (Rand.Int (1, 4))
    end for
    result sequence
end generateSequence

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

procedure randAppendSequence (var sequence : string)
    sequence += intstr (Rand.Int (1, 4))
end randAppendSequence

procedure getColorsFromSequence (var arrColors : array 1 .. * of int, sequence : string)
    for i : 1 .. length (sequence)
	case strint (sequence (i)) of
	    label BTN_GREEN :
		arrColors (i) := UNLIT_GREEN
	    label BTN_RED :
		arrColors (i) := UNLIT_RED
	    label BTN_BLUE :
		arrColors (i) := UNLIT_BLUE
	    label BTN_YELLOW :
		arrColors (i) := UNLIT_YELLOW
	end case
    end for
end getColorsFromSequence


procedure drawScore (score : int, turn : int)
    Font.Draw (I18N_SCORE + intstr (score), SCORE_RENDER_X, SCORE_RENDER_Y, segoe, white)
    Font.Draw (I18N_TURN + intstr (turn), TURN_RENDER_X, TURN_RENDER_Y, segoe, white)

    View.Update
end drawScore

procedure renderLitColor (btnNumber : int)
    Pic.Draw (arrSimon (btnNumber), 5, 0, picCopy)
    drawScore (scoreNumber, turnNumber)
    View.Update
end renderLitColor

procedure drawBackground (bgColor : int)
    drawfillbox (0, 0, maxx, maxy, bgColor)
    View.Update
end drawBackground

procedure renderBlank
    renderLitColor (BTN_UNLIT)
end renderBlank

procedure drawStatus (message : string)
    Font.Draw (message, 10, maxy - 50, segoe, white)
    View.Update
end drawStatus


procedure renderBuffer
    drawBackground (black)
    drawStatus (I18N_LOADING)
    delay (1000)
    cls
    drawBackground (black)
end renderBuffer

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



procedure failState
    for i : 0 .. 360
	Draw.FillArc (maxx div 2, maxy div 2, maxx, maxy, 0, i, white)
	delay (5)
	View.Update
    end for
    Pic.Draw (failScreen, 0, 0, picCopy)
    Font.Draw (intstr(scoreNumber), maxx - 300, 45, segoeBold, white)
    View.Update
end failState


procedure winState
    for i : 0 .. 360
	Draw.FillArc (maxx div 2, maxy div 2, maxx, maxy, 0, i, red)
	delay (5)
	View.Update
    end for
    Pic.Draw (winScreen, 0, 0, picCopy)
    Font.Draw (intstr(scoreNumber), maxx - 300, 45, segoeBold, white)
    View.Update
end winState


procedure mainLoop
    var x, y, buttonNumber, buttonUpDown : int
    var failStateTrue : boolean := false
    var correctButtonPresses : int := 0
    var sequence : string := ""
    renderBuffer
    for r : 1 .. ROUND_LIMIT
	turnNumber := r
	randAppendSequence (sequence)
	var arrColors : array 1 .. length (sequence) of int
	getColorsFromSequence (arrColors, sequence)
	drawBackground (black)
	renderBlank
	drawStatus (I18N_SIMON_TURN)
	renderSequence (sequence)
	drawBackground (black)
	renderBlank
	drawStatus (I18N_YOUR_TURN)

	for i : 1 .. length (sequence)
	    var selectedColor : int
	    selectedColor := black
	    loop
		var buttonDown : int
		Mouse.Where (x, y, buttonDown)
		selectedColor := whatdotcolor (x, y)
		exit when buttonDown = 1 and selectedColor not= black
	    end loop
	    play ("B")
	    loop
		var buttonUp : int
		Mouse.Where (x, y, buttonUp)
		renderLitColor (getBtnFromUnlit (selectedColor))
		exit when buttonUp = 0
	    end loop
	    if getBtnFromUnlit (selectedColor) not= strint (sequence (i)) then
		failStateTrue := true
		exit
	    end if
	    scoreNumber += 1
	    renderBlank
	end for
	if failStateTrue then
	    exit
	end if
    end for
    if failStateTrue then
	failState
    else
	winState
    end if
end mainLoop




drawBackground (41)

var x, y, button, buttonupdown : int

Pic.Draw (startScreen, 0, 0, picCopy)
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



