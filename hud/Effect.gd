extends ColorRect

var start_angle = -PI/2
var current_angle = 0.0

func _process(delta):
	material.set("shader_param/start_angle", start_angle)
	material.set("shader_param/current_angle", current_angle)