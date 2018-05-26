extends KinematicBody2D

export var mass = 1
var merged = false
var motion = Vector2()
var rotate

onready var arrows = Util.player.get_node("Camera2D/CanvasLayer/Arrows")
onready var camera = Util.player.get_node("Camera2D")
var arrow

func _ready():
	arrow = preload("res://Nodes/Arrow.tscn").instance()
	arrow.position = Vector2(200, 200)
	arrows.add_child(arrow)
	
	var indicator = $Sprite.duplicate(DUPLICATE_USE_INSTANCING)
	var sc = min(1, arrow.texture.get_width() * 0.5 / float(gets($Sprite).get_width()))
	indicator.scale = Vector2(sc, sc)
#	indicator.show_behind_parent = true
	arrow.add_child(indicator)
	indicator.position.x -= 4
	indicator.raise()
	if randi() % 101 < 100:
		rotate = randf() - randf()
	else:
		rotate = 1 # YOU SPIN ME ROUND
	mass = gets($Sprite).get_width() * gets($Sprite).get_height()

func gets(sprite):
	if sprite.get_class() == "Sprite":
		return sprite.texture
	else:
		return sprite.frames.get_frame(sprite.animation, sprite.frame)

func _process(delta):
	if !merged:
		arrow.position.x = min(max(arrow.texture.get_width()/2, (global_position - camera.get_camera_screen_center()).x + 960), 1920 - arrow.texture.get_width()/2)
		arrow.position.y = min(max(arrow.texture.get_height()/2, (global_position - camera.get_camera_screen_center()).y + 540), 1080 - arrow.texture.get_height()/2)
		
		var dist = (global_position - (camera.get_camera_screen_center() + arrow.position - Vector2(960, 540)))
		arrow.rotation = dist.angle()
		arrow.visible = (abs(dist.y) >= arrow.texture.get_height()/3 or abs(dist.x) >= arrow.texture.get_width()/3)
		
		rotation_degrees += rotate
		
		if Util.player.mass > mass:
			var gravity = (Util.player.position - position).normalized()
			
			var movementSpeed = (Util.player.mass - mass) / (Util.player.position - position).length() * 10
			if movementSpeed > 100:
				movementSpeed = 100
			var collision = move_and_collide(gravity * movementSpeed * delta)
			
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
	
func hug_player():
	var vec = (Util.player.get_node("Core").global_position - global_position).normalized()
	move_and_slide(vec*50)