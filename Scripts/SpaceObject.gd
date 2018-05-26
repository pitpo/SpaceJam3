extends KinematicBody2D

export var mass = 1
var merged = false
var motion = Vector2()

onready var arrows = Util.player.get_node("Camera2D/CanvasLayer/Arrows")
onready var camera = Util.player.get_node("Camera2D")
var arrow

func _ready():
	arrow = preload("res://Nodes/Arrow.tscn").instance()
	arrow.position = Vector2(200, 200)
	arrows.add_child(arrow)

func _process(delta):
	if !merged:
		arrow.position.x = min(max(arrow.texture.get_width()/2, (global_position - camera.get_camera_screen_center()).x + 960), 1920 - arrow.texture.get_width()/2)
		arrow.position.y = min(max(arrow.texture.get_height()/2, (global_position - camera.get_camera_screen_center()).y + 540), 1080 - arrow.texture.get_height()/2)
		
		var dist = (global_position - (camera.get_camera_screen_center() + arrow.position - Vector2(960, 540)))
		arrow.rotation = dist.angle()
		arrow.visible = (abs(dist.y) >= arrow.texture.get_height()/3 or abs(dist.x) >= arrow.texture.get_width()/3)
		
		if Util.player.mass > mass:
			var gravity = (Util.player.position - position).normalized()
			motion += gravity
			
			var collision = move_and_collide(motion)
			
			if collision and collision.collider.is_in_group("player"):
				collision.collider.add_object(self)
				set_collision_layer_bit(0, false)
				set_collision_mask_bit(0, false)
		
		else:
			Util.player.gravitate(self)
	else:
		arrow.visible = false

func add_object(object):
	var gp = object.global_position
	object.merged = true
	
	object.get_parent().remove_child(object)
	add_child(object)
	object.add_to_group("player")
	
	object.global_position = gp
	Util.player.mass += mass