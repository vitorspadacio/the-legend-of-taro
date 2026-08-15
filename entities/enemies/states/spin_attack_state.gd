@icon("res://assets/icons/state.svg")
class_name EnemySpinAttackState extends EnemyAttackState

func enter() -> void:
	enemy.animation.play_no_direction("spin")
	set_attack_direction(enemy.movement.direction)
	enemy.attack_area.activate()
	enemy.blackboard.can_decide = false
	on_cooldown = true
	timer = 0

func physics_process(delta: float) -> EnemyState:
	enemy.movement.roll(3)
	timer += delta
	if timer >= duration:
		enemy.blackboard.can_decide = true
	return null
