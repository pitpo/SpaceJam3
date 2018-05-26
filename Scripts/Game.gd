extends Node2D

onready var background = $ParallaxBackground/ParallaxLayer/Background
onready var start_color = background.modulate

export(PackedScene) var SmallTrash
export(PackedScene) var MediumTrash
export(PackedScene) var Shoe

func _ready():
	randomize()
	
	for i in range(100):
		var cloud = load("res://Nodes/Cloud.tscn").instance()
		cloud.position = Vector2(rand_range(-100000, 100000), rand_range(-100000, 100000))
		cloud.z_index = rand_range(-100, 0)
		$Clouds.add_child(cloud)
	
	generate_belt(88000)

func _process(delta):
	background.modulate.r = min(start_color.r + Util.player.position.length() / 1000000, 1)
	background.modulate.b = min(max(start_color.b - (Util.player.position.length() - 533500) / 1000000, 0), start_color.b)
	background.modulate.g = min(max(start_color.g - (Util.player.position.length() - 1400000) / 1000000, 0), start_color.g)
	$Clouds.modulate = background.modulate
	
	var surroundingArea = getSurroundingArea()
	
	for trash in get_tree().get_nodes_in_group("trash"):
		if trash.global_position.x > surroundingArea.topRight.x || trash.global_position.x < surroundingArea.topLeft.x || trash.global_position.y > surroundingArea.bottomLeft.y || trash.global_position.y < surroundingArea.topLeft.y:
			trash.queue_free()


func generate_belt(distance):
	for i in range(500):
		var trash = preload("res://Nodes/SpaceObjects/SmallTrash.tscn").instance()
		add_child(trash)
		var angle = randf() * PI * 2
		trash.position = Vector2(sin(angle) * distance, cos(angle) * distance)
		
		var sc = 0.5 + randf()*2
		trash.scale = Vector2(sc, sc)

func getSurroundingArea():
	var camPos = $Player/Camera2D.get_camera_screen_center()
	var camScale = $Player/Camera2D.zoom.x
	var topLeft = Vector2(camPos.x-camScale*(1920+960), camPos.y-camScale*(1080+540))
	var bottomRight = Vector2(camPos.x+camScale*(1920+960), camPos.y+camScale*(1080+540))
	var topRight = Vector2(bottomRight.x, topLeft.y)
	var bottomLeft = Vector2(topLeft.x, bottomRight.y)
	return {"topLeft": topLeft, "topRight": topRight, "bottomLeft": bottomLeft, "bottomRight": bottomRight}

func _on_SpawnTimer_timeout():
	# this is solid content lmao, might optimize it and make it easier to read someday
	var spawnArea = getSurroundingArea()
	var xDir = $Player.velocity.x > 0
	var yDir = $Player.velocity.y > 0
	var dir = abs($Player.velocity.x) > abs($Player.velocity.y)
	var camPos = $Player/Camera2D.get_camera_screen_center()
	var camScale = $Player/Camera2D.zoom.x
	for i in range(randi() % 5):
		var xPos
		var yPos
		if dir:
			if xDir:
				xPos = rand_range(camPos.x+960*camScale, spawnArea.topRight.x)
			else:
				xPos = rand_range(spawnArea.topLeft.x, camPos.x-960*camScale)
			yPos = rand_range(spawnArea.topLeft.y, spawnArea.bottomLeft.y)
		else:
			if yDir:
				yPos = rand_range(camPos.y+540*camScale, spawnArea.bottomLeft.y)
			else:
				yPos = rand_range(spawnArea.topLeft.y, camPos.y-540*camScale)
			xPos = rand_range(spawnArea.topLeft.x, spawnArea.topRight.x)
		var type = randi() % 100
		var trash
		if type < 80:
			trash = SmallTrash.instance()
			var sc = 0.5 + randf()*2
			trash.scale = Vector2(sc, sc)
		elif type < 81:
			trash = load("res://Nodes/Cloud.tscn").instance()
			trash.z_index = rand_range(-100, 0)
			trash.position = Vector2(xPos, yPos)
			$Clouds.add_child(trash)
		elif type < 98:
			trash = MediumTrash.instance()
			var sc = 0.5 + randf()*2
			trash.scale = Vector2(sc, sc)
		else :
			trash = Shoe.instance()
		
		add_child(trash)
		trash.add_to_group("trash")
		trash.global_position = Vector2(xPos, yPos)
		
