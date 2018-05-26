extends Node

func _ready():
	var trash1 = load("res://Nodes/SpaceObjects/SmallTrash.tscn")
	var trash2 = load("res://Nodes/SpaceObjects/MediumTrash.tscn")
	
	for i in range(300):
		var trash = [trash1, trash2][randi() % 2].instance()
		trash.position.x = rand_range(10000, 20000) * sign(randf() - 0.5)
		trash.position.y = (abs(randf() * trash.position.x/8) - 1250) * sign(randf() - 0.5)
		print(trash.position.y)
		get_parent().call_deferred("add_child", trash)