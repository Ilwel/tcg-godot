@tool
class_name Hand extends Node2D

@export var hand_radius: int = 100
@export var angle_limit: float = 25
@export var max_card_spread_angle: float = 5

@onready var collision_shape: CollisionShape2D = $DebugShape
@onready var card_manager = $CardManager

var hand: Array = []

func add_card(card: Card):
	hand.push_back(card)
	card_manager.add_child(card)
	reposition_cards()
	
func remove_card(index: int) -> Card:
	var removing_card = hand[index]
	hand.remove_at(index)
	card_manager.remove_child(removing_card)
	reposition_cards()
	return removing_card

func reposition_cards():
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var current_angle = -(card_spread * (hand.size() - 1))/2 - 90
	for card in hand:
		update_card_transform(card, current_angle)
		current_angle += card_spread		

func update_card_transform(card: Card, angle_in_drag: float):
	var tween = Globals.create_smooth_tween()
	tween.tween_property(card, "position", get_card_position(angle_in_drag), 0.15)
	tween.tween_property(card, "rotation", deg_to_rad(angle_in_drag + 90), 0.15)

func get_card_position(angle_in_deg: float) -> Vector2:
	var x:float = hand_radius * cos(deg_to_rad(angle_in_deg))
	var y:float = hand_radius * sin(deg_to_rad(angle_in_deg))
	
	return Vector2(x, y)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)
	
	pass
