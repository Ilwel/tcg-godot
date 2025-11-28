@tool
class_name Hand extends Node2D

@export var hand_radius: int = 1000
@export var angle_limit: float = 50
@export var max_card_spread_angle: float = 5

@onready var collision_shape: CollisionShape2D = $DebugShape
@onready var card_manager = $CardManager

const HOVER_OFFSET = 30

var hand: Array = []

func add_card(card: Card, source: Node2D):
	hand.push_back(card)
	card_manager.add_child(card)
	card.global_position = source.global_position
	card.rotation = source.rotation
	reposition_cards()
	
func remove_card(card: Card) -> Card:
	if card in hand:
		hand.erase(card)
		card_manager.remove_child(card)
		reposition_cards()	
	return card

func reposition_cards():
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var current_angle = -(card_spread * (hand.size() - 1))/2 - 90
	for card in hand:
		update_card_transform(card, current_angle, false)
		current_angle += card_spread		

func reposition_cards_with_highlight(highlight: Card):
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var current_angle = -(card_spread * (hand.size() - 1))/2 - 90
	for card in hand:
		var is_highlighing = card == highlight
		# só isso, sem tween extra aqui
		update_card_transform(card, current_angle, is_highlighing)
		current_angle += card_spread
			
func update_card_transform(card: Card, angle_in_deg: float, is_highlighting: bool):
	var tween = Globals.create_smooth_tween()

	var target_pos = get_card_position(angle_in_deg)
	var target_rot = deg_to_rad(angle_in_deg + 90)

	# scale
	var target_scale: Vector2
	if is_highlighting:
		target_scale = Vector2(1.2, 1.2)
	else:
		target_scale = Vector2.ONE

	# face position
	var target_face_pos: Vector2 = card.default_face_pos
	if is_highlighting:
		target_face_pos.y -= HOVER_OFFSET

	# animate everything at once
	tween.tween_property(card, "scale", target_scale, 0.05)
	tween.tween_property(card.face, "position", target_face_pos, 0.15)
	tween.tween_property(card, "position", target_pos, 0.15)
	tween.tween_property(card, "rotation", target_rot, 0.15)

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
