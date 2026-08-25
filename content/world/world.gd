extends Node2D


# @onready var snow: GPUParticles2D = %Snow
# @onready var fog: TextureRect = %Fog

# @onready var transition: ColorRect = %Transition
# @onready var music: AudioStreamPlayer = %Music
# @onready var color_correction: ColorRect = %ColorCorrection
# @onready var pivot: Node2D = %Pivot
# @onready var player_ui: Control = %PlayerUi

@export var starting_level: PackedScene

@onready var cloud: GPUParticles2D = %Cloud
@onready var leaf: GPUParticles2D = %Leaf
@onready var rain: GPUParticles2D = %Rain
@onready var raylight: GPUParticles2D = %Raylight

@onready var camera_controller: CameraController = %CameraController

var current_level: Level

func _ready():
	generate_level(starting_level)

	var player = get_tree().get_first_node_in_group("player")
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.target = player

func apply_environment(resource_environment: ResourceEnvironment) -> void:
	cloud.emitting = ResourceEnvironment.Meteo.CLOUD in resource_environment.meteo_list
	leaf.emitting = ResourceEnvironment.Meteo.LEAF in resource_environment.meteo_list
	rain.emitting = ResourceEnvironment.Meteo.RAIN in resource_environment.meteo_list
	raylight.emitting = ResourceEnvironment.Meteo.RAY in resource_environment.meteo_list

	if resource_environment.music:
		Audio.play_music(resource_environment.music)
	else:
		Audio.stop_music()

func generate_level(level_scene: PackedScene):
	if current_level:
		current_level.queue_free()
	current_level = level_scene.instantiate()
	add_child(current_level)
	current_level.environment_area.environment_changed.connect(apply_environment)


# func apply_environment(resource_environment: ResourceEnvironment):
# 	# METEO
# 	if !resource_environment:
# 		return
# 	rain.emitting = ResourceEnvironment.Meteo.RAIN in resource_environment.meteo_list
# 	snow.emitting = ResourceEnvironment.Meteo.SNOW in resource_environment.meteo_list
# 	cloud.emitting = ResourceEnvironment.Meteo.CLOUD in resource_environment.meteo_list
# 	leaf.emitting = ResourceEnvironment.Meteo.LEAF in resource_environment.meteo_list
# 	fog.active = ResourceEnvironment.Meteo.FOG in resource_environment.meteo_list
# 	raylight.emitting = ResourceEnvironment.Meteo.RAY in resource_environment.meteo_list
# 	# MUSIC
# 	if resource_environment.music:
# 		music.change_music(resource_environment.music)
# 	else:
# 		music.stop_music()
	
# 	# GRADIENT
# 	color_correction.gradient = resource_environment.color_gradient


# func play_transition(type: Transition.Type):
# 	transition
