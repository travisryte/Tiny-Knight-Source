extends "res://characters/Boss/scripts/states/calm.gd"

var idle_time

func enter():
	owner.play("react", "backwards")
	idle_time = rand_range (2, 5)
	yield(owner.get_node("Anim"), "animation_finished")
	owner.sprites["react"].frame = 3
	owner.play("idle")
	return .enter()

func update(delta):
	idle_time -= delta
	if idle_time < 0:
		owner.play("idle")
		randomize()
		idle_time = rand_range (2, 5)
	if abs(owner.player_position.x) > 60 and owner.sprites["idle"].frame == 0:
		emit_signal("finished", "walk")
	return .update(delta)

func respond(event, x):
	.respond(event, x)

func exit():
	owner.sprites["idle"].frame = 0