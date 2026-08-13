class_name Player extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)
signal died()

@export var collision: CollisionShape2D
@export var damage_area: DamageArea
@export var sprite: Sprite2D
@export var sprite_attack: Sprite2D
@export var state_machine: StateMachine

@export_category("components")
@export var animation: AnimationComponent
@export var health: HealthComponent
@export var input: InputComponent
@export var movement: MovementComponent

##### Core #####

func _ready() -> void:
	state_machine.init_player(self)
	damage_area.damage_taken.connect(_on_damage_taken)
	health.died.connect(died.emit)

func _process(delta: float) -> void:
	input.update_commands()
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

##### Functions #####

func update_direction() -> void:
	movement.direction = input.direction
	animation.direction_name = movement.direction_name
	animation.play()

##### Side Effects #####

func _on_damage_taken(attack_area: AttackArea) -> void:
	health.damage(attack_area.damage)
	damage_taken.emit(attack_area)
