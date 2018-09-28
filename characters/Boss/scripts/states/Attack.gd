extends "res://characters/Boss/scripts/state.gd"

var attack
var hurt_time = 0.0

func enter():
	attack = owner.sprites["attack"]
	owner.hitbox(false)
	owner.play("react")
	yield(owner.get_node("Anim"), "animation_finished")
	owner.sprites["react"].frame = 3
	owner.play("attack")

func update(delta):
	if hurt_time < 0:
		attack.modulate = Color(1,1,1,1)
	else:
		hurt_time -= delta
	if attack.frame == 7:
		attack.get_node("AttackArea").monitoring = true
	else:
		attack.get_node("AttackArea").monitoring = false
	if attack.frame < 7 or attack.frame > 16:
		owner.hitbox(true)
	else:
		attack.modulate = Color(1,1,1,1)
		owner.hitbox(false)

func respond(event, x):
	if event == "damage":
		if owner.health_points > 0:
			attack.modulate = Color(10,10,10,10)
			hurt_time = 0.2
		else:
			emit_signal("finished", "die")

func _on_animation_finished(anim_name):
	if anim_name == "attack":
		owner.hitbox(true)
		emit_signal("finished","idle")
