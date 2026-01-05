extends Node2D

@onready var coin_toss_screen = $ModalScreen
@onready var player_deck = $PlayerScreenMatch/HandNDeck/PlayerDeck
@onready var enemy_deck = $PlayerScreenMatch2/HandNDeck/PlayerDeck
@onready var main_camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_toss_screen.visible = true


func _process(_delta: float) -> void:
	if Match.get_current_game_phase() == Match.GamePhaseType.Init:
		Match.set_game_phase(Match.GamePhaseType.FirstDraw)
		player_deck.deck_collision.disabled = true
		await player_deck.draw_n(5, true)
		Globals.snap_camera_up(main_camera, 540)
		await enemy_deck.draw_n(5, true)
		player_deck.deck_collision.disabled = false	
		Match.set_game_phase(Match.GamePhaseType.Game)
		if Match.get_current_player() == Match.PlayerType.Player:
			Globals.snap_camera_down(main_camera, 540)
		else:
			pass
	if Match.get_current_game_phase() == Match.GamePhaseType.Game:
		if Match.get_current_player() == Match.PlayerType.Player:
			Globals.player_match_controls = true
		else:
			Globals.player_match_controls = false
