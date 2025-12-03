extends Node2D

enum PlayerType{
	Player,
	Enemy
}

enum GamePhaseType{
	Toss,
	Init,
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
