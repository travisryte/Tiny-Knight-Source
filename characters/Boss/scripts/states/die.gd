extends "res://characters/Boss/scripts/state.gd"

func enter():
	owner.hitbox(false)
	owner.play("dead")

func exit():
	return


func update(delta):
	return

func _on_animation_finished(anim_name):
	owner.emit_signal("game_ended", "res://levels/MainMenu.tscn")
	owner.queue_free()