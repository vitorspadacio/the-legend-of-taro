@icon("res://assets/icons/state.svg")
class_name PlayerIdleState extends PlayerState

var decelerate_rate: float = 15

func init() -> void:
	state_name = "idle"
	
func enter() -> void:
	player.velocity.x = 0
	player.velocity.y = 0
	
func exit() -> void:
	pass

func handle_input(event: InputEvent) -> PlayerState:
	if player.controller.idle:
		return idle
	if player.controller.walk:
		return walk
	if player.controller.roll:
		return roll
	if player.controller.attack:
		return attack
	if player.controller.swing:
		return swing
	return null
	
func physics_process(delta: float) -> PlayerState:
	var deceleration_x: float = player.velocity.x * decelerate_rate * delta
	player.velocity.x -= deceleration_x
	return null
	
func process(_delta: float) -> PlayerState:
	return null
