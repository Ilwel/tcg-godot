extends Node2D

enum PlayerType{
	Player,
	Enemy
}

enum GamePhaseType{
	Toss,
	Init,
	FirstDraw,
	Game,
	End
}

enum TurnPhaseType{
	Draw,
	Main,
	Battle,
	Main2,
	End
}

@onready var players = {
	PlayerType.Player: {	
		"hp": 10,
		"deck": [],
		"runes": [],
		"hand": []
	},
	PlayerType.Enemy: {
		"hp": 10,
		"deck": [],
		"runes": [],
		"hand": []
	}
}

@onready var match_game :={
	"current_player": PlayerType.Player,
	"current_turn_phase": TurnPhaseType.Draw,
	"current_game_phase": GamePhaseType.Toss,
	"turn_count": 0
}

# ============= MATCH GAME STATE GETTERS =============

func get_current_turn_phase() -> TurnPhaseType:
	return match_game["current_turn_phase"]

func get_current_player() -> PlayerType:
	return match_game["current_player"]

func get_current_game_phase() -> GamePhaseType:
	return match_game["current_game_phase"]

func get_turn_count() -> int:
	return match_game["turn_count"]

# ============= MATCH GAME STATE SETTERS =============

func set_turn_phase(phase: TurnPhaseType) -> void:
	match_game["current_turn_phase"] = phase

func set_current_player(player: PlayerType) -> void:
	match_game["current_player"] = player

func set_game_phase(phase: GamePhaseType) -> void:
	match_game["current_game_phase"] = phase

func set_turn_count(count: int) -> void:
	match_game["turn_count"] = count

func increment_turn_count() -> void:
	match_game["turn_count"] += 1

# ============= PLAYER DATA GETTERS =============

func get_player_hp(player: PlayerType) -> int:
	return players[player]["hp"]

func get_player_deck(player: PlayerType) -> Array:
	return players[player]["deck"]

func get_player_runes(player: PlayerType) -> Array:
	return players[player]["runes"]

func get_player_hand(player: PlayerType) -> Array:
	return players[player]["hand"]

# ============= PLAYER DATA SETTERS =============

func set_player_hp(player: PlayerType, hp: int) -> void:
	players[player]["hp"] = hp

func modify_player_hp(player: PlayerType, amount: int) -> void:
	players[player]["hp"] += amount

func set_player_deck(player: PlayerType, deck: Array) -> void:
	players[player]["deck"] = deck

func set_player_runes(player: PlayerType, runes: Array) -> void:
	players[player]["runes"] = runes

func set_player_hand(player: PlayerType, hand: Array) -> void:
	players[player]["hand"] = hand
