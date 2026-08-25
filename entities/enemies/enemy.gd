class_name Enemy extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)

@export var attack_area: AttackArea
@export var collision: CollisionShape2D
@export var damage_area: DamageArea
@export var decision_engine: DecisionEngine
@export var hazard_area: HazardArea
@export var sprite: Sprite2D
@export var state_machine: StateMachine
@export var navigation: NavigationAgent2D

@export_category("components")
@export var animation: AnimationComponent
@export var health: HealthComponent
@export var jump: JumpComponent
@export var movement: MovementComponent

var blackboard: Blackboard

##### Core #####

func _ready() -> void:
	if decision_engine:
		blackboard = Blackboard.new()
		decision_engine.blackboard = blackboard

	state_machine.init_enemy(self)
	damage_area.damage_taken.connect(_on_damage_taken)
	if jump:
		jump.height_changed.connect(_on_jump_height_changed)

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.died.connect(_on_player_death)

func _process(delta: float) -> void:
	if blackboard:
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

func _on_damage_taken(attacker_area: AttackArea) -> void:
	damage_taken.emit(attacker_area)
	health.damage(attacker_area.damage)

func _on_player_death() -> void:
	blackboard.target = null

func _on_jump_height_changed(height: float) -> void:
	sprite.position.y = - height
