extends Node

export var size = 10000
export var number = 300

func _ready():
	var trash1 = load("res://Nodes/SpaceObjects/SmallTrash.tscn")
	var trash2 = load("res://Nodes/SpaceObjects/MediumTrash.tscn")
	
	for i in range(number):
		var trash = [trash1, trash2][randi() % 2].instance()
		trash.position.x = rand_range(size, size*2) * sign(randf() - 0.5)
		trash.position.y = (abs(randf() * trash.position.x/8) - size/8) * sign(randf() - 0.5)
		print(trash.position.y)
		get_parent().call_deferred("add_child", trash)