class_name AnimationComponent extends Node

@export var animation_player: AnimationPlayer

var current_animation_name: String
var direction_name := "down"

func play(animation_name: String = current_animation_name) -> void:
	current_animation_name = animation_name
	animation_player.play("%s_%s" % [current_animation_name, direction_name])

func play_no_direction(animation_name: String = current_animation_name) -> void:
	current_animation_name = animation_name
	animation_player.play("%s" % current_animation_name)
