extends VBoxContainer

@onready var coin1 = $CoinDecision/Coin
@onready var coin2 = $CoinDecision/Coin2
@onready var coin_decision = $CoinDecision
@onready var label = $Label
@onready var throw_coin = $HBoxContainer/Coin
@onready var result_lbl = $ResultLbl
@onready var modal_screen = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	throw_coin.visible = false
	coin1.click.connect(on_coin_click)
	coin2.click.connect(on_coin_click)

func on_coin_click(face_parm):
	coin_decision.visible = false
	label.visible = false
	throw_coin.visible = true
	var throw = await throw_coin.flip()
	if throw == face_parm:
		label.text = "You Go First"
		label.visible = true
		Match.match_game["current_player"] = Match.PlayerType.Player
	else:
		label.text = "You Go Second"
		label.visible = true
		Match.match_game["current_player"] = Match.PlayerType.Enemy
	
	await get_tree().create_timer(1.0).timeout
	modal_screen.visible = false
	Match.match_game["current_game_phase"] = Match.GamePhaseType.Init
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
