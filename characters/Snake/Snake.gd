extends KinematicBody2D

var velocity = Vector2()

const FLOOR_NORMAL = Vector2(0, -1)

export var Acceleration = 300
export var BaseSpeed = 20
export var health_points = 2
const SIDING_CHANGE_SPEED = 10
const GRAVITY = 700
var recover_time = 0

enum State {ALIVE, HURT, DYING}
var current_state = ALIVE

var new_anim = ""
var pushed = false
var push_count = 3
var direction = 1

func _ready():
	$Label.text = str(health_points)

func _physics_process(delta):

	if push_count < 3:
		velocity.x += Acceleration * direction
		push_count += 3
	
	velocity.y += GRAVITY*delta
	#Wall Detection
	if current_state == ALIVE:
		if $Hitbox.monitoring:
			var body_list = $Hitbox.get_overlapping_bodies()
			for body in body_list:
				body.call("hurt", $Middle.global_position)
		if change_direction():
			direction *= -1
			velocity.x = BaseSpeed*direction
		velocity.x = lerp(velocity.x, BaseSpeed * direction, 0.05)
		velocity.x = lerp(velocity.x, 0 , 0.01)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
#	print(velocity.x)
	$Sprite.scale.x = -direction
	
	if $Anim.current_animation != new_anim:
		$Anim.play(new_anim)

func change_direction():
	if $Sprite/CastWall.is_colliding() or not $Sprite/CastFloor.is_colliding():
		return true
	return false

func recover():
	if recover_time < 3:
		#print("recovering")
		recover_time += 1
	elif is_on_floor(): 
		recover_time = 0
		$Anim.play("walk")
		$Hitbox.monitoring = true
		current_state = ALIVE

func push():
	push_count = 0
	
func enemy_hurt(attacker, damage):
	$Hitbox.monitoring = false
	health_points -= damage
	velocity = (global_position - attacker.global_position).normalized() * 100\
			+ Vector2(0, -200)
	$Label.text = str(health_points)
	
	if health_points <= 0:
		$Anim.play("dying")
		$Hitbox.monitorable = false
		return
	
	$Anim.play("hurt")
	current_state = HURT
	recover_time = 0
	#print(global_position, hurt_position)

func _on_Visible_screen_exited():
	if velocity.y > 300 and current_state == HURT:
		print("dying out of screen")
		$Anim.play("dying")
		$Hitbox.monitorable = false
		return