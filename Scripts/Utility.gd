extends Node

var player
var textures = {}

func _ready():
	textures.Small = [load("res://Sprites/SpaceObjects/SmallRock01.png"), load("res://Sprites/SpaceObjects/SmallRock02.png"), load("res://Sprites/SpaceObjects/SmallRock03.png"), load("res://Sprites/SpaceObjects/AsteroidSmallRock01.png"), load("res://Sprites/SpaceObjects/AsteroidSmallRock02.png"), load("res://Sprites/SpaceObjects/TransitionSmallRock01.png"), load("res://Sprites/SpaceObjects/TransitionSmallRock02.png")]
	textures.Medium = [load("res://Sprites/SpaceObjects/MediumRock01.png"), load("res://Sprites/SpaceObjects/AsteroidMediumRock01.png"), load("res://Sprites/SpaceObjects/TransitionMediumRock01.png")]