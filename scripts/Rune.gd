@tool
extends Control

enum RuneType { FIRE, WATER, EARTH, AIR, DARK, LIGHT }
@export var rune_type: RuneType
@onready var sprite: Sprite2D = $RuneSprite
@export var enabled:bool = false

func get_rune_sprite():
	if rune_type == RuneType.FIRE:
		return preload("res://assets/runes/FireRune.png")
	elif rune_type == RuneType.WATER:
		return preload("res://assets/runes/WaterRune.png")
	elif rune_type == RuneType.EARTH:
		return preload("res://assets/runes/EarthRune.png")
	elif rune_type == RuneType.AIR:
		return preload("res://assets/runes/AirRune.png")
	elif rune_type == RuneType.DARK:
		return preload("res://assets/runes/DarkRune.png")
	elif rune_type == RuneType.LIGHT:
		return preload("res://assets/runes/LightRune.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = get_rune_sprite()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.texture = get_rune_sprite()
	if !enabled:
		sprite.modulate.a = 0.5
	else:
		sprite.modulate.a = 1
