extends Control

onready var start = $HBoxContainer/VBoxContainer/VBoxContainer/StartButton
onready var quit = $HBoxContainer/VBoxContainer/VBoxContainer/QuitButton
onready var path = "res://levels/Intro.tscn"

func _ready():
	get_tree().paused = false
	start.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene(path)


func _on_QuitButton_pressed():
	get_tree().quit()
