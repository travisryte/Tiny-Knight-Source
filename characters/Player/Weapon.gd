extends Area2D

var damage = 1

func _on_Weapon_area_entered( area ):
	if "enemy" in area.owner.get_groups():
		print("enemy hit")
		area.owner.call("enemy_hurt", owner, damage)