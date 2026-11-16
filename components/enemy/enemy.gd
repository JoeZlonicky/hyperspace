class_name Enemy
extends CharacterBody2D


signal destroyed

const PROJECTILE_SCENE := preload("uid://dpieyslanfybp") as PackedScene

var health: int = 10
var target: Vector2 = Vector2.ZERO
var moving_down: bool = true
var move_speed: float = 100.0
var acceleration: float = 400.0
var top_boundary: float = 40.0
var bottom_boundary: float = 270.0 - 40.0

@onready var shoot_sfx: AudioStreamPlayer = %ShootSFX
@onready var projectile_spawn_position: Marker2D = %ProjectileSpawnPosition


func _physics_process(delta: float) -> void:
	if global_position.y < top_boundary:
		moving_down = true
	elif global_position.y > bottom_boundary:
		moving_down = false
	
	var input := Vector2(-0.25, 1.0 if moving_down else -1.0).normalized()
	velocity = velocity.move_toward(input * move_speed, acceleration * delta)
	move_and_slide()


# Fire projectile
func shoot() -> void:
	var game := get_tree().current_scene
	var projectile := PROJECTILE_SCENE.instantiate() as Projectile
	projectile.direction = Vector2.LEFT
	projectile.set_collision_mask_player()
	projectile.modulate = Color("ff0000")
	projectile.speed /= 2
	game.add_child(projectile)
	projectile.global_position = projectile_spawn_position.global_position
	shoot_sfx.play()


# Take damage (destroyed)
func hit() -> void:
	health -= 1
	if health >= 1:
		return
	
	destroyed.emit()
	queue_free()
