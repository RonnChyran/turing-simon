View.Set ("graphics:720;850,nobuttonbar")

var arrSimon : array 1 .. 5 of int
arrSimon (1) := Pic.FileNew ("assets/textures/green.gif")
arrSimon (2) := Pic.FileNew ("assets/textures/red.gif")
arrSimon (3) := Pic.FileNew ("assets/textures/blue.gif")
arrSimon (4) := Pic.FileNew ("assets/textures/yellow.gif")
arrSimon (5) := Pic.FileNew ("assets/textures/base.gif")

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

procedure renderSequence (sequence : string)
    for i : 1 .. length (sequence)
	renderLitColor (strint (sequence (i)))
	play ("AA")
	delay (1000)
	renderBlank
	delay (500)
    end for
end renderSequence

var sequence : string := ""
for r : 1 .. ROUND_LIMIT

    randAppendSequence(sequence)
    var arrColors : array 1 .. length (sequence) of int
    getColorsFromSequence (arrColors, sequence)
    put sequence

    renderSequence (sequence)
    renderBlank

    for i : 1 .. length (sequence)
	var sequenceBtn : int := strint (sequence (i))
	var x, y, buttonNumber, buttonUpDown : int
	var selectedColor : int
	loop
	    Mouse.ButtonWait ("down", x, y, buttonNumber, buttonUpDown)
	    selectedColor := whatdotcolor (x, y)
	    exit when selectedColor not= white and selectedColor not= black
	end loop

	if selectedColor = getUnlitColor (sequenceBtn) then
	    renderLitColor (sequenceBtn)
	    Mouse.ButtonWait ("up", x, y, buttonNumber, buttonUpDown)
	    renderBlank
	    delay(500)
	else
	    renderLitColor (sequenceBtn)
	    delay (1000)
	    renderBlank
	    exit
	end if
    end for
end for
