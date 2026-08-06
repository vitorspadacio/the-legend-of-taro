class_name Enemy extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)

@export var collision: CollisionShape2D
@export var damage_area: DamageArea
@export var decision_engine: DecisionEngine
@export var sprite: Sprite2D
@export var state_machine: StateMachine
@export var navigation: NavigationAgent2D

@export_category("components")
@export var animation: AnimationComponent
@export var health: HealthComponent
@export var movement: MovementComponent

var blackboard: Blackboard

##### Core #####

func _ready() -> void:
	blackboard = Blackboard.new()
	decision_engine.blackboard = blackboard
	state_machine.init_enemy(self)
	damage_area.damage_taken.connect(_on_damage_taken)

func _process(delta: float) -> void:
	var target: Player = blackboard.target
	var distance: float = blackboard.distance_to_target
	%Label.text = "target: %s \ndist: %s" % [target, distance]
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	if blackboard == null:
		return

	blackboard.update_distance_to_target(global_position)
	state_machine.change_state(decision_engine.decide())
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

##### Functions #####

##### Side Effects #####

func _on_damage_taken(attack_area: AttackArea) -> void:
	damage_taken.emit(attack_area)
	health.damage(attack_area.damage)
