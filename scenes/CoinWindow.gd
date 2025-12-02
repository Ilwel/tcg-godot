extends VBoxContainer

@onready var coin1 = $CoinDecision/Coin
@onready var coin2 = $CoinDecision/Coin2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin1.click.connect(on_coin_click)
	coin2.click.connect(on_coin_click)

func on_coin_click(face_parm):
	print("bubble ", face_parm)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
