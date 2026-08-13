extends Node

const SMOKE_EFFECT = preload("uid://bdl7svonujls4")

func create_smoke(position: Vector2) -> void:
	var effect = SMOKE_EFFECT.instantiate()
	effect.global_position = position
	get_tree().current_scene.add_child(effect)

# const DUST_EFFECT = preload("uid://csyk5rcv71xrs")
# const HIT_PARTICLES = preload("uid://ciw3wt00w7r61")

# signal camera_shook(strenght: float)

# func _create_dust_effect(position: Vector2) -> DustEffect:
# 	var dust: DustEffect = DUST_EFFECT.instantiate()
# 	dust.global_position = position
# 	add_child(dust)
# 	return dust

# func jump_dust(position: Vector2) -> void:
# 	var dust: DustEffect = _create_dust_effect(position)
# 	dust.start(DustEffect.TYPE.JUMP)

# func land_dust(position: Vector2) -> void:
# 	var dust: DustEffect = _create_dust_effect(position)
# 	dust.start(DustEffect.TYPE.LAND)

# func hit_dust(position: Vector2) -> void:
# 	var dust: DustEffect = _create_dust_effect(position)
# 	dust.start(DustEffect.TYPE.HIT)

# func camera_shake(strenght: float = 1.0) -> void:
# 	camera_shook.emit(strenght)

# func hit_particles(position: Vector2, direction: Vector2, settings: HitParticleSettings) -> void:
# 	var particles: HitParticles = HIT_PARTICLES.instantiate()
# 	add_child(particles)
# 	particles.global_position = position
# 	particles.start(direction, settings)
