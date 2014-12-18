import GUI
View.Set ("graphics:720;800,nobuttonbar")


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

procedure renderLitColor (btnNumber : int)
    Pic.Draw (arrSimon (btnNumber), 5, 0, picCopy)
end renderLitColor

procedure renderBlank
    renderLitColor (BTN_UNLIT)
end renderBlank


procedure drawBackground (bgColor : int)
    drawfillbox (0, 0, maxx, maxy, bgColor)
end drawBackground

procedure renderBuffer
drawBackground(black)
Font.Draw ("loading...", 10, maxy - 100, segoe, white)
delay(1000)
cls 
drawBackground(black)
end renderBuffer

procedure renderSequence (sequence : string)
    for i : 1 .. length (sequence)
	renderLitColor (strint (sequence (i)))
	play ("AA")
	delay (1000)
	renderBlank
	delay (500)
    end for
end renderSequence



procedure failState (correctButtonPresses : int, roundsCompleted : int)
    GUI.HideWindow (defWinId)
    var failWindow : int := Window.Open ("title:Window A,graphics:500;500,position:center;center")
    cls
    put "You pressed ", correctButtonPresses, " buttons correctly"
    put "Your score is ", roundsCompleted, " rounds"

    var quitBtn : int := GUI.CreateButton (maxx div 4, maxy div 4, 0, "Quit", GUI.Quit)
    var restartBtn : int := GUI.CreateButton (maxx div 4 * 2, maxy div 4, 0, "Restart", GUI.Quit)
    loop
	exit when GUI.ProcessEvent
    end loop
end failState


procedure winState
end winState


procedure mainLoop
    var x, y, buttonNumber, buttonUpDown : int

    var failStateTrue : boolean := false
    var correctButtonPresses : int := 0
    var sequence : string := ""
    renderBuffer
    for r : 1 .. ROUND_LIMIT
	randAppendSequence (sequence)
	var arrColors : array 1 .. length (sequence) of int
	getColorsFromSequence (arrColors, sequence)
	put sequence

	renderSequence (sequence)
	renderBlank

	for i : 1 .. length (sequence)
	    var selectedColor : int
	    selectedColor := black
	    loop
		var buttonDown : int 
		Mouse.Where(x, y, buttonDown)
		selectedColor := whatdotcolor(x,y)
		exit when buttonDown = 1 and selectedColor not= black
	    end loop
	    
	    loop
		var buttonUp : int 
		Mouse.Where(x, y, buttonUp)
		renderLitColor(getBtnFromUnlit(selectedColor))
		exit when buttonUp = 0
	    end loop
	    renderBlank
	    delay(1000)
	end for
    end for
    winState
end mainLoop




drawBackground (41)

var x, y, button, buttonupdown : int

Font.Draw ("Simon", maxx div 4, 600, segoe, white)
Font.Draw ("PLAY!", maxx - 100, 10, segoe, white)
Draw.FillBox (0, 0, maxx, 100, 54)

loop

    Mouse.Where (x, y, button)
    if y > 100 then
	Font.Draw ("PLAY!", maxx - 100, 10, segoeBold, white)
    end if
    if y < 100 then
	Font.Draw ("PLAY!", maxx - 100, 10, segoeBold, red)
    end if
    if button = 1 and y < 100 then
	loop
	    exit when not Mouse.ButtonMoved ("down")
	    Mouse.ButtonWait ("down", x, y, button, buttonupdown)
	end loop
	cls
	mainLoop
	exit
    end if
end loop



