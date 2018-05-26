extends Node

var direction = Vector2(randf(), randf()).normalized()

func _ready():
	pass

func _process(delta):
	get_parent().move_and_collide(direction)
	if randf() < 0.2: direction = direction.rotated(-PI/8 + randf() * PI/4)