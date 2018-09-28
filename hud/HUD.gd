extends CanvasLayer

var path = ""

func _ready():
	get_tree().paused = true
	$Tween.set_active(true)
	if get_parent().name == "NextLevel":
		get_parent().connect("transition", self, "_on_NextLevel_transition")
	$Effect.material.set("shader_param/flip", false)
	$Tween.interpolate_property($Effect, 'current_angle', 0.0, TAU, 0.8, \
			Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(delta):
	if $Tween.is_active():
		print($Effect.current_angle)

func _on_NextLevel_transition(scene):
	path = scene
	get_tree().paused = true
	$Effect.material.set("shader_param/flip", true)
	$Tween.set_active(true)
	$Tween.interpolate_property($Effect, 'current_angle', TAU, 0.0, 0.8, \
			Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	$Tween.set_active(false)
	if $Effect.current_angle == 0.0:
		get_tree().change_scene(path)
	elif $Effect.current_angle == TAU:
		get_tree().paused = false