extends "res://characters/Boss/scripts/states/calm.gd"

const FLOOR_NORMAL = Vector2(0, -1)
var velocity = Vector2(0, 0)
var speed = -40
var direction = 1
var time_backwards = 0.0

func enter():
	owner.play("walk")
	return .enter()

func respond(event, x):
	.respond(event, x)

func update(delta):
	if abs(owner.player_position.x) < 60 and owner.sprites["walk"].frame == 0:
		emit_signal("finished", "idle")
	if owner.position.x < 0:
		time_backwards = rand_range(3,6)
		direction = -1
		owner.play("walk", "backwards")
#		print("walking backwards")
	elif owner.position.x > 288 or (time_backwards < 0 and direction == -1):
		direction = 1
		owner.play("walk")
	time_backwards -= delta
	move()
	return .update(delta)

func move():
	match owner.sprites["walk"].frame:
		0, 8:
			velocity.x = 0
		_:
			velocity.x = speed*direction
#	print(velocity.x)
	owner.move_and_slide(velocity, FLOOR_NORMAL)