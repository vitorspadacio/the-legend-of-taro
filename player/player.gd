class_name Player extends CharacterBody2D

signal damage_taken(attack_area: AttackArea)

@export var collision: CollisionShape2D
@export var damage_area: DamageArea
@export var sprite: Sprite2D
@export var sprite_attack: Sprite2D
@export var state_machine: StateMachine

@export_category("components")
@export var animation: AnimationComponent
@export var input: InputComponent
@export var movement: MovementComponent

##### Core #####

func _ready() -> void:
	if get_tree().get_first_node_in_group("player") != self:
		self.queue_free()
		return
	state_machine.init(self)
	self.call_deferred("reparent", get_tree().root)

	damage_area.damage_taken.connect(_on_damage_taken)

func _process(delta: float) -> void:
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	input.update(event)
	state_machine.handle_input(event)

##### Functions #####

##### Side Effects #####

func _on_damage_taken(attack_area: AttackArea) -> void:
	damage_taken.emit(attack_area)
	print("Acertou com dano %s" % attack_area.damage)
