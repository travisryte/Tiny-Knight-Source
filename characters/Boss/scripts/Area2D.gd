extends Area2D

func _on_Area2D_body_entered(body):
	if body.has_method("hurt"):
		body.call("hurt", owner.global_position, 2)