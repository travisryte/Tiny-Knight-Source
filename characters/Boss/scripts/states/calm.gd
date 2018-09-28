extends "res://characters/Boss/scripts/state.gd"



func update(delta):
	owner.attack_time -= delta
	if owner.attack_time < 0 and abs(owner.player_position.x) < 120:
		owner.attack_time = rand_range (1,3)
		print("attacking in ", owner.attack_time)
		emit_signal("finished", "attack")


func respond(event, x):
	if event == "damage":
		if owner.health_points > 0:
			emit_signal("finished", "hurt")
		else:
			emit_signal("finished", "die")