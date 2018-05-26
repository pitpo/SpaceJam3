extends Node

export(int) var speed = 1
var direction = Vector2(randf(), randf()).normalized()

func _ready():
	pass

func _process(delta):
	if !get_parent().is_in_group("player"):
		get_parent().move_and_collide(direction * speed)
	if randf() < 0.2: direction = direction.rotated(-PI/8 + randf() * PI/4)