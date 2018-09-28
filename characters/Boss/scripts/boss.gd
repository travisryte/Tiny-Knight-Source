extends KinematicBody2D

var velocity = Vector2()
var new_anim = ""

signal state_changed(state)
signal sprite_switched(new_sprite)

const FLOOR_NORMAL = Vector2(0, -1)
const MAX_SPEED = 10
const GRAVITY = 700

onready var states_map = {}
onready var current_state
onready var sprites = $Sprites.sprites
var player
var player_position = Vector2() # relative to the boss
var attack_cooldown = 0
var health_points = 15
var attack_time = rand_range (1,3)

signal game_ended(main_menu)

func _ready():
	randomize()
	$Health.set_text(str(health_points))
	ready_states($States)
	print(states_map)
	current_state = states_map["idle"]
	if owner != null:
		player = weakref(owner.get_node("Player"))
	$Anim.set_animation_process_mode(0)
	connect("sprite_switched", $Sprites, "_on_sprite_switched")
	current_state.enter()

func ready_states(states):
	for child_state in states.get_children():
		if child_state.get_children() == []:
			states_map[child_state.name.to_lower()] = child_state
			print(states_map)
			child_state.connect("finished", self, "_change_state")
		elif child_state.get_children() != []:
			ready_states(child_state)
	connect("game_ended", $"../HUD", "_on_NextLevel_transition")

func _physics_process(delta):
	if player != null and player.get_ref():
		player_position = player.get_ref().global_position - global_position
	current_state.update(delta)

# pass to the state dict of attacker and damage of attack
func enemy_hurt(attacker, damage):
	health_points -= damage
	$Health.set_text(str(health_points))
	current_state.respond("damage", health_points)

# Plays a new animation
func play(anim_name, arg=null):
#	if $Anim.current_animation == "anim_name":
#		$Anim.set_speed_scale(1) if arg == null else $Anim.set_speed_scale(-1)
	$Anim.stop(true)
	$Anim.play(anim_name) if arg == null else $Anim.play_backwards(anim_name)
#	print("animating " + $Anim.get_current_animation())
	emit_signal("sprite_switched", anim_name)

func _change_state(state):
	current_state.exit()
	print("%s state changed to %s state" % [current_state.name, state])
	current_state = states_map[state]
	current_state.enter()

func _on_Anim_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func hitbox(value):
	$Sprites/Hitbox.monitorable = value
#	print("You can hit him" if value else "You can't hit him")
