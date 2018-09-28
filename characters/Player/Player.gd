extends KinematicBody2D


var velocity = Vector2()
var recover_time = 0
export var airborne_attack_limit = 1

const FLOOR_NORMAL = Vector2(0, -1)
const ACCELERATION = 700
const MAX_SPEED = 180
const GRAVITY = 700
const JUMP_SPEED = -300
const MIN_JUMP_SPEED = -200

enum State {ALIVE, HURT, DIE}
var current_state = ALIVE
var attacking = false
var airborne_attacks = 0
var health_points = 15
var invincibility = false
onready var health_text = $HealthBar

signal game_ended(main_menu)
onready var level = get_node("..") if get_node("..") != null else null

func _ready():
	var HUD = level.find_node("HUD")
	print(HUD)
	connect("game_ended", HUD, "_on_NextLevel_transition")
	health_text.set_text(str(health_points))
	Engine.set_target_fps(Engine.get_iterations_per_second())

func _physics_process(delta):
	var right_key = Input.is_action_pressed("ui_right")
	var left_key = Input.is_action_pressed("ui_left")
	var new_anim = "idle"
	var gravity_force = GRAVITY * delta
	velocity.y += gravity_force

	match current_state:
		ALIVE:
			### Movement ###
			var direction = int(right_key) - int(left_key)
			if direction == 0:
				velocity.x = lerp(velocity.x, 0, 0.2)
			else: 
				velocity.x += direction * ACCELERATION * delta
			if is_on_floor():
				airborne_attacks = 0
				if Input.is_action_just_pressed("ui_up") and not attacking:
					velocity.y = JUMP_SPEED
				if attacking:
					velocity.x = lerp(velocity.x, 0, 0.9)
			else:
				if velocity.y < MIN_JUMP_SPEED and \
						Input.is_action_just_released("ui_up"):
					 velocity.y = MIN_JUMP_SPEED
			velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
				
			### Attacking ###
			if not attacking and Input.is_action_just_pressed("ui_attack"):
				$"Sound/Stab".play()
				attacking = true
				if not is_on_floor() and airborne_attacks == 0:
					airborne_attacks += 1

			### Animation ###
			if attacking:
				new_anim = "stab"
			else:
				if direction:
					$Sprite.scale.x = direction
				new_anim = "jump" if velocity.y < 0 else "fall"
				if is_on_floor():
					new_anim = "walk" if velocity.x != 0 else "idle"
				
		HURT:
			new_anim = "hurt"
			$Sprite.scale.x = 1 if velocity.x > 0 else -1\
		
		DIE:
			new_anim = "die"
			if $Sprite/Die.frame != 7:
				velocity.y -= gravity_force * 0.5
			else:
				velocity.y = lerp(velocity.y, -gravity_force * 0.1, 0.2)

			velocity.x = lerp(velocity.x, gravity_force*0.1*delta, 0.9)
	velocity = move_and_slide(velocity,FLOOR_NORMAL)
	if $Anim.current_animation != new_anim:
		$Anim.play(new_anim)
		
	#seriously, this is just to make the nodes visible and invisible again.
	var children = $Sprite.get_children()
	for child in children:
		var path = get_path_to(child)
		var track_path = $Anim.get_animation(new_anim).track_get_path(0)
		if path.get_name(1) == track_path.get_name(1):
			child.visible = true
		else:
			child.visible = false
#	print(velocity)

func recover():
	if recover_time < 1:
		print("recovering")
		recover_time += 1
	else: 
		recover_time = 0
		current_state = ALIVE
		print("I'm invincible")
		$InvincibilityTimer.start()
		$Invincible.play("invulnerable")

func hurt(hurt_position, damage=1):
	if invincibility or current_state == DIE:
		return
	$Sound/Hurt.play()
	attacking = false
	health_points -= damage
	health_text.set_text(str(health_points))
	print("received ", damage)
	velocity = Vector2(200, -200)
	velocity.x *= 1 if (global_position - hurt_position).x > 0 else -1
	invincibility = true
	if health_points > 0:
		current_state = HURT
	else:
		die("no health")

func _on_Anim_animation_finished( anim_name ):
	if anim_name == "stab":
		attacking = false
	if anim_name == "die":
		print("going back to menu")
		emit_signal("game_ended", "res://levels/MainMenu.tscn")

func die(option=null):
	if current_state == DIE:
		return
	$"Sound/Dead".play()
	print("dead")
	if option == "pit":
		velocity = Vector2(0, -400)
	elif option == "no health":
		velocity.y = 0
	current_state = DIE

func _on_InvincibilityTimer_timeout():
	$Invincible.stop()
	$Sprite.set_modulate(Color(1, 1, 1, 1))
	invincibility = false

func fade_away():
	if find_node("Camera") == null:
		return
	var child_camera = $Camera
	if child_camera.is_current():
		var camera_position = child_camera.global_position
		remove_child(child_camera)
		get_parent().add_child(child_camera)
		child_camera.position = camera_position
	queue_free()