extends Node2D

# @export var starting_map: PackedScene

# @onready var rain: GPUParticles2D = %Rain
# @onready var snow: GPUParticles2D = %Snow
# @onready var cloud: GPUParticles2D = %Cloud
# @onready var leaf: GPUParticles2D = %Leaf
# @onready var raylight: GPUParticles2D = %Raylight
# @onready var fog: TextureRect = %Fog

# @onready var transition: ColorRect = %Transition
# @onready var music: AudioStreamPlayer = %Music
# @onready var color_correction: ColorRect = %ColorCorrection
# @onready var pivot: Node2D = %Pivot
# @onready var player_ui: Control = %PlayerUi

@onready var camera_controller: CameraController = %CameraController
@onready var environment_area: EnvironmentArea = %EnvironmentArea

func _ready():
	environment_area.environment_changed.connect(apply_environment)
	var player = get_tree().get_first_node_in_group("player")
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.target = player
	# generate_map(starting_map)
	# camera_controller.animation_finished.connect(on_camera_animation_finished)

func apply_environment() -> void:
	print("mudou")
	pass

# func on_camera_animation_finished():
	# pivot.position = camera_grid.global_position

# func generate_map(map_scene: PackedScene):
# 	if map:
# 		map.queue_free()
# 	map = starting_map.instantiate()
# 	add_child(map)
# 	map.environment_area.environment_changed.connect(apply_environment)


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
