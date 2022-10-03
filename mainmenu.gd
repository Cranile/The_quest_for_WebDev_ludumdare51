extends Node

var currentPrompt = 0;
func _ready():
	$Timer.start()
	pass

func _on_AudioStreamPlayer_finished():
	print("audio end")
	get_tree().change_scene("res://Main.tscn")


func _on_Timer_timeout():
	currentPrompt += 1;
	if(currentPrompt == 6):
		$container/bg/logsContainer/Label5.text = "Hard drive . . . OK \n Sound card . . . OK"
	if(currentPrompt >= 6):
		$Timer.stop()
		return
	get_node("container/bg/logsContainer/Label"+str(currentPrompt)).show()
