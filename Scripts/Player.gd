extends KinematicBody2D

var mass = 100
export(int) var SPEED # will be calculted dynamically from mass in the future
var velocity = Vector2()

func _init():
	Util.player = self

func _ready():
	# spawn next to a planet (earth? XD), orbitting around it
	var pos = $"../StartingPlanet".position
	# adjust Y position to spawn at the top of the planet
	pos.y -= $"../StartingPlanet/Sprite".texture.get_width() * $"../StartingPlanet".scale.y / 2
	pos.y -= 160
	position = pos
	
func _process(delta):

	# MOVEMENT
	# use controls to alter the vector
	
	# current implementation is temporary
	if Input.is_action_pressed("ui_right") && velocity.x < 20:
		velocity.x += 1
	elif velocity.x > 0:
		velocity.x -= 1
		
	if Input.is_action_pressed("ui_left") && velocity.x > -20:
		velocity.x -= 1
	elif velocity.x < 0:
		velocity.x += 1
		
	if Input.is_action_pressed("ui_up") && velocity.y > -20:
		velocity.y -= 1
	elif velocity.y < 0:
		velocity.y += 1
		
	if Input.is_action_pressed("ui_down") && velocity.y < 20:
		velocity.y += 1
	elif velocity.y > 0:
		velocity.y -= 1
	
	var curVelocity = velocity
	if velocity.length() > 0:
		curVelocity = curVelocity.normalized() * SPEED
	
	if velocity.length_squared() > 0: rotation = velocity.angle()
	move_and_slide(curVelocity * delta*50)

const MAX_GRAVITY = 2

func gravitate(object):
	var dist = object.position - position
	var gravity = dist.normalized() * object.mass / dist.length() * 10
	if gravity.length() > MAX_GRAVITY: gravity = gravity.normalized() * MAX_GRAVITY
	
	var collision = move_and_collide(gravity)
	
	if collision and collision.collider.is_in_group("space_object"):
		print(collision.collider.name)

func add_object(object):
	var gp = object.global_position
	var gr = object.global_rotation
	object.merged = true
	
	object.get_parent().remove_child(object)
	add_child(object)
	object.add_to_group("player")
	
	object.global_position = gp
	object.global_rotation = gr
	Util.player.mass += mass