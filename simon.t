View.Set ("graphics:779;850,nobuttonbar")

var arrSimon : array 1 .. 5 of int
arrSimon (1) := Pic.FileNew ("assets/textures/green.jpg")
arrSimon (2) := Pic.FileNew ("assets/textures/red.jpg")
arrSimon (3) := Pic.FileNew ("assets/textures/blue.jpg")
arrSimon (4) := Pic.FileNew ("assets/textures/yellow.jpg")
arrSimon (5) := Pic.FileNew ("assets/textures/blank.jpg")

function generateSequence (iSequenceLength : int) : string
    var sequence : string := ""
    for i : 1 .. iSequenceLength
	sequence += intstr (Rand.Int (1, 4))
    end for
    result sequence
end generateSequence

procedure renderBlank 
	Pic.Draw (arrSimon (5), 5, 0, picCopy)
end renderBlank

procedure renderSequence (sequence : string)
    for i : 1 .. length (sequence)
	Pic.Draw (arrSimon (strint (sequence (i))), 5, 0, picCopy)
	play ("AA")
	delay (1000)
	renderBlank 
	delay (500)
    end for
end renderSequence



var sequence : string := generateSequence (5)
put sequence

renderSequence(sequence)

renderBlank

