class_name DialogBox extends Control

const ACTOR_BOX = preload("uid://ce0d8o2iu2fia")
const NO_ACTOR_BOX = preload("uid://0326kqvjr78f")

signal has_no_more_lines

@onready var actor: Label = $Actor
@onready var box: TextureRect = $Box
@onready var button: Control = $Button
@onready var text: RichTextLabel = $Text

var current_line: int = 0
var dialog: Array[DialogLine] = []
var is_writing: bool = false
var style: DialogComponent.DialogTypes
var tween: Tween

func _ready() -> void:
	text.visible_characters = 0
	button.visible = false
	box.offset_transform_scale = Vector2(0.05, 0.05)
	_define_style()
	await _animate_box(Vector2(1.0, 1.0))
	await _show_text()
	_animate_arrow()


func _define_style() -> void:
	match style:
		DialogComponent.DialogTypes.NORMAL:
			actor.visible = true
			box.texture = ACTOR_BOX
			box.size = Vector2(300, 58)
			box.position = Vector2(0, 118)
			text.size = Vector2(290, 32)
			text.position = Vector2(11, 133)

		DialogComponent.DialogTypes.NO_ACTOR:
			actor.visible = false
			box.texture = NO_ACTOR_BOX
			box.size = Vector2(300, 50)
			box.position = Vector2(0, 126)
			text.size = Vector2(290, 32)
			text.position = Vector2(11, 133)

		DialogComponent.DialogTypes.CENTER:
			actor.visible = false
			box.texture = NO_ACTOR_BOX
			box.size = Vector2(210, 50)
			box.position = Vector2(50, 50)
			text.size = Vector2(205, 34)
			text.position = Vector2(58, 58)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		if not is_writing:
			_go_to_next_line()
		else:
			tween.set_speed_scale(20.0)

func _animate_box(new_scale: Vector2, speed: float = 0.25) -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(box, "offset_transform_scale", new_scale, speed)
	await tween.finished


func _show_text() -> void:
	var line = dialog[current_line]
	text.visible_characters = 0
	actor.text = line["actor"]
	text.text = line["text"]
	
	if tween:
		tween.kill()

	is_writing = true
	tween = create_tween()
	tween.tween_property(
		text,
		"visible_characters",
		text.text.length(),
		text.text.length() / 50.0
	)
	await tween.finished
	_show_button(true)
	is_writing = false


func _shake_box() -> void:
	box.offset_transform_scale = Vector2(1.1, 1.1)
	await _animate_box(Vector2(1.0, 1.0), 0.1)


func _show_button(must_show: bool) -> void:
	button.visible = must_show

func _go_to_next_line() -> void:
	current_line = current_line + 1
	if current_line + 1 > dialog.size():
		_close()
	else:
		await _shake_box()
		_show_button(false)
		_show_text()
		return


func _close() -> void:
	actor.visible = false
	text.visible = false
	button.visible = false
	await _animate_box(Vector2(0.05, 0.05))
	has_no_more_lines.emit()
	queue_free()


func _animate_arrow() -> void:
	var arrow_tween = create_tween().set_loops()

	arrow_tween.tween_property(
		button,
		"position:y",
		button.position.y + 1.5,
		0.4
	)
	arrow_tween.tween_property(
		button,
		"position:y",
		button.position.y,
		0.4
	)
