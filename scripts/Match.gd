extends Node

enum PlayerType{
	Player,
	Enemy
}

enum PhaseType{
	Draw,
	Main,
	Battle,
	Main2,
	End
}

@onready var player := {
	"hp": 10,
	"deck": [],
	"runes": [],
	"hand": []
}

@onready var enemy:={
	"hp": 10,
	"deck": [],
	"runes": [],
	"hand": []
}

@onready var match :={
	"current_player": PlayerType.Player,
	"current_phase": PhaseType.Draw,
	"turn_count": 0
}

func _ready():
	pass
	
