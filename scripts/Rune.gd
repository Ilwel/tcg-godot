@tool
extends Control

enum RuneType { FIRE, WATER, EARTH, AIR, DARK, LIGHT }
@export var rune_type: RuneType
@onready var sprite: Sprite2D = $RuneSprite
@onready var bright_animation: AnimatedSprite2D = $BrightAnimation
@export var enabled:bool = true
@export var ready_to_use = false

func get_rune_color() -> Color:
	if rune_type == RuneType.FIRE:
		return Color("f22760ff")
	elif rune_type == RuneType.WATER:
		return Color("005debff")
	elif rune_type == RuneType.EARTH:
		return Color("53fa43ff")
	elif rune_type == RuneType.AIR:
		return Color("63cbe9ff")
	elif rune_type == RuneType.DARK:
		return Color("#181825")
	elif rune_type == RuneType.LIGHT:
		return Color("#ffffff")
	else:
		return Color("ffffff")
		
func _set_intensity(value):
	var c = sprite.modulate
	c.r = value
	c.g = value
	c.b = value
	modulate = c
	
func set_glow(state: bool):
	if bright_animation:
		bright_animation.visible = state
	if state:
		if rune_type == RuneType.DARK:
			_set_intensity(4.0)
		else:
			_set_intensity(2.0)
		bright_animation.play()
	else:
		_set_intensity(1.0)
		bright_animation.stop()
		
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.modulate = get_rune_color()
	set_glow(ready_to_use)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.modulate = get_rune_color()
	set_glow(ready_to_use)
	if !enabled:
		sprite.modulate.a = 0.2
	else:
		sprite.modulate.a = 1
