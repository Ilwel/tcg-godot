@tool
class_name Card extends Node2D

signal hovered
signal hovered_off

const dark_theme_constrast = "#cdd6f4"
const dark_theme_main = "#11111b"

const HOVER_OFFSET := 30

@export var card_id: String = ""
@export var cost: int = 0
@export var card_name: String = "King"
@export var atk: int = 0
@export var hp: int = 0
@export var card_image: Node2D 
@export var max_offset_shadow: float = 50.0
@export var theme:String = "dark"

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

func _ready():
	get_parent().connect_card_signals(self)
	#theme_handler()
	#cost_lbl.visible = true;
	cost_lbl.set_text(str(cost))
	name_lbl.set_text(card_name)
	atk_lbl.set_text(str(atk))
	hp_lbl.set_text(str(hp))
	
func _process(delta):
	_update_graphics_values()

func show_details(show: bool):
	if show:
		pass
	else:
		pass
		
		
func theme_handler():
	if theme == "dark":
		cost_lbl.add_theme_color_override("font_color", dark_theme_main)
		cost_sprite.modulate = Color.WHITE
		canvas_sprite.modulate = Color.WHITE
		atk_lbl.add_theme_color_override("font_color", dark_theme_main)
		hp_lbl.add_theme_color_override("font_color", dark_theme_main)
		bar_lbl.add_theme_color_override("font_color", dark_theme_main)
		name_lbl.add_theme_color_override("font_color", dark_theme_constrast)
	else:
		cost_lbl.add_theme_color_override("font_color", dark_theme_constrast)
		cost_sprite.modulate = Color(dark_theme_main)
		canvas_sprite.modulate = Color(dark_theme_main)
		atk_lbl.add_theme_color_override("font_color", dark_theme_constrast)
		hp_lbl.add_theme_color_override("font_color", dark_theme_constrast)
		bar_lbl.add_theme_color_override("font_color", dark_theme_constrast)
		name_lbl.add_theme_color_override("font_color", dark_theme_main)

func set_card_values(dict: Dictionary):
	cost = int(dict["cost"])
	card_name = dict["card_name"]
	atk = int(dict["atk"])
	hp = int(dict["hp"])
	
	_update_graphics_values()
	
func _update_graphics_values():
	theme_handler()
	cost_lbl.set_text(str(cost))
	name_lbl.set_text(card_name)
	atk_lbl.set_text(str(atk))
	hp_lbl.set_text(str(hp))
	
func handle_shadow() -> void:
	# Y position is enver changed.
	# Only x changes depending on how far we are from the center of the screen
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/(center.x)))
	shadow.position.y = 20

func reset_shadow():
	shadow.position = default_shadow_pos

func _on_card_area_mouse_entered() -> void:
	print("test")
	emit_signal("hovered", self)


func _on_card_area_mouse_exited() -> void:
	emit_signal("hovered_off", self)
