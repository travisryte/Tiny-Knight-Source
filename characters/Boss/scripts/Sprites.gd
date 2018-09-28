extends Node2D

var sprites = {}

func _ready():
	# Sprite node names are added as keys to the dict
	for sprite_node in get_children():
		if sprite_node is Sprite:
			sprites[sprite_node.name.to_lower()] = sprite_node
#	print(sprites) 

func _on_sprite_switched(new_sprite):
	for sprite in sprites:
		if sprite != new_sprite:
			sprites[sprite].visible = false
	sprites[new_sprite].visible = true