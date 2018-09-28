extends Area2D

func _ready():
	connect("body_entered", self, "on_Pit_body_entered")

func on_Pit_body_entered(body):
	body.call("die", "pit")
