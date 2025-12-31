class_name RuneSet extends Node

@export var rune_set_player: Match.PlayerType = Match.PlayerType.Player

@onready var rune1: Rune = $Rune
@onready var rune2: Rune = $Rune2
@onready var rune3: Rune = $Rune3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rune_set_player == Match.PlayerType.Player:
		var runes = Globals.load_deck_runes_from_json("res://assets/decks/init_deck.json")
		runes[0].state = "ready"
		Match.set_player_runes(rune_set_player, runes)
	else:
		var runes = Globals.load_deck_runes_from_json("res://assets/decks/init_deck.json")
		runes[0].state = "ready"
		Match.set_player_runes(rune_set_player, runes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var runes = Match.get_player_runes(rune_set_player)
	rune1.import_rune(runes[0])
	rune2.import_rune(runes[1])
	rune3.import_rune(runes[2])
		
