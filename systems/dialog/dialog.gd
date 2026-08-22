class_name Dialog extends Control

@onready var actor: Label = $Actor
@onready var box: TextureRect = $Box
@onready var button: Control = $Button
@onready var text: RichTextLabel = $Text

var current_line: int = 0
var dialog: Array[Dictionary] = [
	{"actor": "ROGER", "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque malesuada semper dolor, et pellentesque dui vehicula eu. Curabitur nisl tortor, commodo eu risus in, euismod feugiat nibh. Duis luctus."},
	{"actor": "ROGER", "text": "Cala boca!"},
	{"actor": "OUTRO", "text": "Nada fica por acaso, desgraçado!"},
]
var is_writing: bool = false
var tween: Tween

func _ready() -> void:
	text.visible_characters = 0
	button.visible = false
	box.offset_transform_scale = Vector2(0.05, 0.05)
	await _animate_box(Vector2(1.0, 1.0))
	await _show_text()
	_animate_arrow()
	_show_button()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		if not is_writing:
			_go_to_next_line()
		else:
			print("TODO: pular texto")
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
	is_writing = false


func _shake_box() -> void:
	box.offset_transform_scale = Vector2(1.1, 1.1)
	await _animate_box(Vector2(1.0, 1.0), 0.1)


func _show_button() -> void:
	button.visible = true

func _go_to_next_line() -> void:
	current_line = current_line + 1
	if current_line + 1 > dialog.size():
		_close()
	else:
		await _shake_box()
		_show_text()
		return


func _close() -> void:
	actor.visible = false
	text.visible = false
	button.visible = false
	await _animate_box(Vector2(0.05, 0.05))
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
