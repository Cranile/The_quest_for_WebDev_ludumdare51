extends ColorRect

var firstOpen = true

func _on_puzzleMain_visibility_changed():
	if(firstOpen):
		$AnimationPlayer.play("highlight")
		firstOpen = false;
