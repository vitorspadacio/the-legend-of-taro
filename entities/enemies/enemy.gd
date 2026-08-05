class_name Enemy extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)

@export var collision: CollisionShape2D
@export var damage_area: DamageArea
@export var sprite: Sprite2D
@export var state_machine: StateMachine

@export_category("components")
@export var animation: AnimationComponent
@export var health: HealthComponent
@export var movement: MovementComponent

##### Core #####

func _ready() -> void:
	state_machine.init_enemy(self)
	damage_area.damage_taken.connect(_on_damage_taken)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	# movement.direction = input.walk
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

##### Functions #####

##### Side Effects #####

func _on_damage_taken(attack_area: AttackArea) -> void:
	damage_taken.emit(attack_area)
