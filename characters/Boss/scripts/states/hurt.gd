extends "res://characters/Boss/scripts/state.gd"

func enter():
	owner.hitbox(false)
	owner.play("hurt")

func update(delta):
	owner.attack_time -= delta

func _on_animation_finished(anim_name):
	owner.hitbox(true)
	emit_signal("finished","idle")