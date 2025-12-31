@tool
class_name Rune extends Control

enum RuneType { Fire, Water, Earth, Air, Dark, Light }
enum RuneState { Disabled, Enabled, Ready }
@export var rune_type: RuneType
@export var state: RuneState = RuneState.Disabled
@onready var sprite: Sprite2D = $RuneSprite
@onready var bright_animation: AnimatedSprite2D = $BrightAnimation

var string_rune_to_string_type = {
	"fire": RuneType.Fire,
	"water": RuneType.Water,
	"earth": RuneType.Earth,
	"air": RuneType.Air,
	"dark": RuneType.Dark,
	"light": RuneType.Light
}

var string_state_to_string_type = {
	"disabled": RuneState.Disabled,
	"enabled": RuneState.Enabled,
	"ready": RuneState.Ready
}

func import_rune(rune_obj):
	rune_type = string_rune_to_string_type[rune_obj.type]
	state = string_state_to_string_type[rune_obj.state]

func get_rune_color() -> Color:
	if rune_type == RuneType.Fire:
		return Color("f22760ff")
	elif rune_type == RuneType.Water:
		return Color("005debff")
	elif rune_type == RuneType.Earth:
		return Color("53fa43ff")
	elif rune_type == RuneType.Air:
		return Color("63cbe9ff")
	elif rune_type == RuneType.Dark:
		return Color("#181825")
	elif rune_type == RuneType.Light:
		return Color("#ffffff")
	else:
		return Color("ffffff")
		
func _set_intensity(value):
	var c = sprite.modulate
	c.r = value
	c.g = value
	c.b = value
	modulate = c
	
func set_glow(glow_state: bool):
	if bright_animation:
		bright_animation.visible = state
	if glow_state:
		if rune_type == RuneType.Dark:
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
	set_glow(state == RuneState.Ready)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sprite.modulate = get_rune_color()
	set_glow(state == RuneState.Ready)
	if state == RuneState.Disabled:
		sprite.modulate.a = 0.2
	else:
		sprite.modulate.a = 1
