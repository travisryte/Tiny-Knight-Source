extends Area2D

export(String, FILE, "*.tscn") var next_level

signal transition(path)

func _on_NextLevel_body_entered( body ):
	if body.name == "Player":
		emit_signal("transition", next_level)