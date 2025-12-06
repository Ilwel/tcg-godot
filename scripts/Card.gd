@tool
class_name Card extends Node2D

signal hovered
signal hovered_off

# Theme colors
const DARK_THEME_CONTRAST = "#cdd6f4"
const DARK_THEME_MAIN = "#11111b"
const LIGHT_THEME_TEXT = Color.WHITE

# Constants
const HOVER_OFFSET := 30

@export var card_id: String = ""
@export var cost: int = 0
@export var card_name: String = "King"
@export var atk: int = 0
@export var hp: int = 0
@export var card_image: Node2D 
@export var max_offset_shadow: float = 50.0
@export var theme:String = "dark"
@export var face_up: bool = true;

@onready var face_card: Node2D = $FaceCard
@onready var card_back: Sprite2D = $CardBack
@onready var cost_lbl: Label = $FaceCard/CostNode/CostLbl
@onready var cost_sprite: Sprite2D = $FaceCard/CostNode/CostSprite
@onready var canvas_sprite: Sprite2D = $FaceCard/ArtCanvas/BackgroundSprite
@onready var name_lbl: Label = $FaceCard/NameNode/NameLbl
@onready var atk_lbl: Label = $FaceCard/HBoxContainer/AtkLbl
@onready var bar_lbl: Label = $FaceCard/HBoxContainer/BarLbl
@onready var hp_lbl: Label = $FaceCard/HBoxContainer/HpLbl
@onready var face: Node2D = $FaceCard
@onready var art: Sprite2D = $FaceCard/ArtCanvas/Art
@onready var default_face_pos: Vector2 = face.position
@onready var shadow: Sprite2D = $Shadow
@onready var default_shadow_pos: Vector2 = shadow.position
@onready var card_collision = $CardArea/CardCollision

func handle_face_up():
	face_card.visible = face_up
	card_back.visible = !face_up
	
func handle_player_touch(player_can_touch: bool = true):
	if card_collision:
		card_collision.disabled = not player_can_touch

func _ready():
	get_parent().connect_card_signals(self)
	handle_face_up()
	_update_graphics_values()
	
func _process(_delta):
	pass

func show_details(_show: bool):
	# TODO: Implement details view if needed
	pass

func theme_handler() -> void:
	var is_dark_theme := theme == "dark"
	_apply_theme_colors(is_dark_theme)
	_apply_sprite_modulation(is_dark_theme)

func _apply_theme_colors(is_dark: bool) -> void:
	var main_color := DARK_THEME_MAIN if is_dark else DARK_THEME_CONTRAST
	var contrast_color := DARK_THEME_CONTRAST if is_dark else DARK_THEME_MAIN
	
	for label in [cost_lbl, atk_lbl, hp_lbl, bar_lbl]:
		label.add_theme_color_override("font_color", main_color)
	
	name_lbl.add_theme_color_override("font_color", contrast_color)

func _apply_sprite_modulation(is_dark: bool) -> void:
	var modulate_color := Color.WHITE if is_dark else Color(DARK_THEME_MAIN)
	cost_sprite.modulate = modulate_color
	canvas_sprite.modulate = modulate_color

func set_card_values(dict: Dictionary):
	cost = int(dict["cost"])
	card_name = dict["card_name"]
	atk = int(dict["atk"])
	hp = int(dict["hp"])
	
	_update_graphics_values()
	
func _update_graphics_values() -> void:
	theme_handler()
	_update_labels()
	
func _update_labels() -> void:
	cost_lbl.set_text(str(cost))
	name_lbl.set_text(card_name)
	atk_lbl.set_text(str(atk))
	hp_lbl.set_text(str(hp))
	
func handle_shadow() -> void:
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/(center.x)))
	shadow.position.y = 20

func reset_shadow():
	shadow.position = default_shadow_pos

func _on_card_area_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_card_area_mouse_exited() -> void:
	emit_signal("hovered_off", self)
