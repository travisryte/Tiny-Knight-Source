# Base state from which other states inherit from

extends Node

signal finished(next_state_name)

# Initializes the state, changes animation, etc
func enter():
	return

# Cleans up the state
func exit():
	return

# Handles any events that passes in
func respond(event, param):
	return

func update(delta):
	return

func _on_animation_finished(anim_name):
	return