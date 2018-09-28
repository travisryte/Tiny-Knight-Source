extends Node

"""
Interface for state machine
Will update the current state
"""

func _ready():
	return


func _physics_process(delta):
	current_state.update(delta)
