class_name Player
extends CharacterBody2D


signal destroyed

const PROJECTILE_SCENE := preload("uid://dpieyslanfybp") as PackedScene

var acceleration: float = 400.0
var move_speed: float = 200

@onready var projectile_spawn_position: Marker2D = %ProjectileSpawnPosition
@onready var shoot_cooldown: Timer = %ShootCooldown
@onready var shoot_sfx: AudioStreamPlayer = %ShootSFX


# Check for shooting
func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and shoot_cooldown.is_stopped():
		shoot()


# Move left/right based on input
func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(input * move_speed, acceleration * delta)
	move_and_slide()


# Fire projectile
func shoot() -> void:
	var game := get_tree().current_scene
	var projectile := PROJECTILE_SCENE.instantiate() as Projectile
	projectile.direction = Vector2.RIGHT
	projectile.modulate = Color("00ff17")
	projectile.set_collision_mask_enemy()
	game.add_child(projectile)
	projectile.global_position = projectile_spawn_position.global_position
	shoot_sfx.play()
	shoot_cooldown.start()


# Damage player (destroy)
func hit() -> void:
	destroyed.emit()
	queue_free()
