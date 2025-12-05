extends Node2D

@onready var coin_toss_screen = $ModalScreen
@onready var player_deck = $HandNDeck/PlayerDeck
@onready var enemy_deck = $HandNDeck/EnemyDeck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_toss_screen.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Match.match_game["current_game_phase"] == Match.GamePhaseType.Init:
		player_deck.deck_collision.disabled = true
		Match.match_game["current_game_phase"] = Match.GamePhaseType.Game
		await player_deck.draw_n(5, true)
		await enemy_deck.draw_n(5, true)
		player_deck.deck_collision.disabled = false
