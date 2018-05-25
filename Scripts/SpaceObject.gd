extends KinematicBody2D

export var mass = 1
var merged = false
var motion = Vector2()

func _ready():
	pass

func _process(delta):
	if !merged:
		var gravity = (Util.player.position - position).normalized()
		motion += gravity
		
		var collision = move_and_collide(motion)
		
		if collision and collision.collider.is_in_group("player"):
#			print(name, " ", collision.collider.name)
			collision.collider.add_object(self)
			add_to_group("player")

func add_object(object):
	object.merged = true
	object.get_parent().remove_child(object)
	add_child(object)