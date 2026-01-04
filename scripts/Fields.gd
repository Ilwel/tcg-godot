extends Control

@export var player: Match.PlayerType = Match.PlayerType.Player

@onready var player_fields = $HBoxContainer3/PlayerFields
@onready var rune_set = $HBoxContainer3/PlayerFields/RuneSet

const PLAYER_FIELDS_Y = 50
const ENEMY_FIELDS_Y = -250
const FIELDS_X = 251


func _ready() -> void:
	global_position.x = FIELDS_X
	if player == Match.PlayerType.Enemy:
		player_fields.move_child(rune_set, 0)
		global_position.y = ENEMY_FIELDS_Y
	else:
		global_position.y = PLAYER_FIELDS_Y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
