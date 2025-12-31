extends Node

@export var player: Match.PlayerType = Match.PlayerType.Player

@onready var player_fields =$HBoxContainer3/PlayerFields

func _ready() -> void:
	var rune_set_instance: RuneSet = preload("res://scenes/RuneSet.tscn").instantiate()
	rune_set_instance.rune_set_player = player
	player_fields.add_child(rune_set_instance)
	if player == Match.PlayerType.Enemy:
		player_fields.move_child(rune_set_instance, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
