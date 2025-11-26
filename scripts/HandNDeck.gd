extends Node

@onready var card:PackedScene = preload("res://scenes/Card.tscn")
@onready var hand = $Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var some_card = card.instantiate()
	hand.add_card(some_card)
	


func _on_button_2_pressed() -> void:
	hand.remove_card(0);
