extends Node2D

@onready var coin_toss_screen = $ModalScreen
@onready var player_deck = $PlayerScreenMatch/HandNDeck/PlayerDeck
@onready var enemy_deck = $PlayerScreenMatch2/HandNDeck/PlayerDeck
@onready var main_camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_toss_screen.visible = true


func _process(_delta: float) -> void:
	if Match.match_game["current_game_phase"] == Match.GamePhaseType.Init:
		player_deck.deck_collision.disabled = true
		Match.match_game["current_game_phase"] = Match.GamePhaseType.Game
		await player_deck.draw_n(5, true)
		Globals.snap_camera_up(main_camera, 540)
		await enemy_deck.draw_n(5, true)
		player_deck.deck_collision.disabled = false	
