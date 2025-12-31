class_name CardSlot extends Control

@export var ace_slot = false

var card_in_slot = false
@onready var sprite = $Sprite2D
@onready var ace_crown_sprite = $AceCrownSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ace_crown_sprite.visible = ace_slot
	if ace_slot:
		sprite.modulate = Color("#f9e2af")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
