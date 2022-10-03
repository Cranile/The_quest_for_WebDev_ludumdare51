extends CanvasLayer

export var inputText = ""

var firstPuzzleOpen = true;

signal submit
signal nextDialogue
signal keyboard

func _on_Button_pressed():
	if(get_parent().disablecoding):
		return;
	emit_signal("submit")

func promptTry(state):
	if(state):
		print("true")
	else:
		print("false")


func _on_codeBtn_pressed(code):
	if(get_parent().disablecoding):
		return;
	emit_signal("keyboard")
	var label = get_node("puzzleContainer/puzzleMain/codeContainer/" + code + "/number").text
	inputText += label
	$puzzleContainer/puzzleMain/codeContainer/title.text = inputText



func _on_closepopup_pressed():
	$popup.hide()


func _on_next_pressed():
	emit_signal("nextDialogue")


func _on_closecv_pressed():
	$cvcontainer.hide()


func _on_closehelp_pressed():
	$help.hide()
