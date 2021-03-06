extends KinematicBody2D

var mass = 4000
var speed = 400
var velocity = Vector2()
var camScale = 0
var recentNodes = []

func _init():
	Util.player = self
	
func _ready():
	# spawn next to a planet (earth? XD), orbitting around it
	var pos = $"../Sun/Earth/Moon".global_position
	# adjust Y position to spawn at the top of the planet
	pos.y -= $"../Sun/Earth/Moon/Sprite".texture.get_width() * $"../Sun/Earth/Moon".scale.y / 2
	pos.y -= 100
	global_position = pos
	
	velocity.x = 1
	velocity.y = 0

func _process(delta):
	# player can slightly manipulate the movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 2 * camScale
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 2 * camScale
	
	if Input.is_action_pressed("ui_down"):
		velocity.y += 2 * camScale
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 2 * camScale
	
	rotation = velocity.normalized().angle()
	velocity = velocity.normalized() * speed
	var collision = move_and_collide(velocity * delta)
	if collision && collision.collider.mass > mass:
		velocity = velocity.slide(collision.normal)
	
	var nodeBuffer = log(mass) * 10
	if recentNodes.size() < nodeBuffer:
		for i in range(1, recentNodes.size()):
			if recentNodes[i]:
				var ref = weakref(recentNodes[i])
				if ref.get_ref(): ref.get_ref().hug_player()
	else:
		for i in range(recentNodes.size() - nodeBuffer + 1, recentNodes.size()):
			if recentNodes[i]:
				var ref = weakref(recentNodes[i])
				if ref.get_ref(): ref.get_ref().hug_player()
		for i in range(1, recentNodes.size() - nodeBuffer):
			if recentNodes[i] && !recentNodes[i].is_in_group("planet"):
				var ref = weakref(recentNodes[i])
				if ref.get_ref(): ref.get_ref().queue_free()
				recentNodes[i] = null
	
	
	if camScale < 2:
		camScale = log(log(mass/1024))
	else:
		camScale = log(mass)/2
	if camScale < 1:
		camScale = 1
	
	if camScale > 2:
		speed = 400 * camScale/4
	else:
		speed = 400 * camScale
	
	var curScale = lerp($Camera2D.zoom.x, camScale, 0.01)
	#curScale = 40
	$Camera2D.zoom = Vector2(curScale, curScale)

func gravitate(object):
	var dist = object.global_position - global_position
	# no idea what is going on down there but it works
	if (dist.length() < 3000):
		var gravity = dist.normalized() * (object.get_node("CollisionShape2D").shape.radius * object.scale.x * 3 / dist.length())
		if mass/object.mass/10 < 0.05:
			velocity += gravity * 0.95
		else:
			velocity += gravity * (1 - mass/object.mass/10)

func add_object(object):
	var gp = object.global_position
	var gr = object.global_rotation
	object.merged = true
	
	object.get_parent().remove_child(object)
	add_child(object)
	object.get_node("Sprite").show_behind_parent = true
	object.z_index = -1
	object.add_to_group("player")
	
	object.global_position = gp
	object.global_rotation = gr
	Util.player.mass += mass
	recentNodes.append(object)
	
func hug_player():
	pass