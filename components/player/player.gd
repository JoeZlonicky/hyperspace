class_name Player
extends CharacterBody2D


signal destroyed

const PROJECTILE_SCENE := preload("uid://dpieyslanfybp") as PackedScene

var max_bullets: int = 50
var bullet_reload_time_ms: float = 50
var bullets_per_shot: int = 5
var acceleration: float = 400.0
var move_speed: float = 200
var control_config := preload("uid://rdu0ef6uidjs") as ControlConfig
var alternate_counter: bool = false

@onready var bullets_remaining: int = max_bullets
@onready var reload_timer_ms: float = 0.0

@onready var top_projectile_spawn_position: Marker2D = %TopProjectileSpawnPosition
@onready var bottom_projectile_spawn_position: Marker2D = %BottomProjectileSpawnPosition
@onready var shoot_cooldown: Timer = %ShootCooldown
@onready var shoot_sfx: AudioStreamPlayer = %ShootSFX
@onready var ammo_display: Node2D = %AmmoDisplay
@onready var bottom_barrel: Sprite2D = %BottomBarrel
@onready var top_barrel: Sprite2D = %TopBarrel


func _ready() -> void:
	_update_ammo_display()


# Check for shooting
func _process(delta: float) -> void:
	reload_timer_ms += delta * 1000.0
	if bullets_remaining == max_bullets:
		reload_timer_ms = 0.0
	else:
		while reload_timer_ms > bullet_reload_time_ms:
			reload_timer_ms -= bullet_reload_time_ms
			bullets_remaining = min(bullets_remaining + 1, max_bullets)
	
	if control_config.is_shoot_pressed():
		shoot()
	top_barrel.scale.y = move_toward(top_barrel.scale.y, 1.0, delta)
	bottom_barrel.scale.y = move_toward(bottom_barrel.scale.y, 1.0, delta)
	_update_ammo_display()


# Move left/right based on input
func _physics_process(delta: float) -> void:
	var input := control_config.get_movement_vector()
	velocity = velocity.move_toward(input * move_speed, acceleration * delta)
	move_and_slide()


# Fire projectile
func shoot() -> void:
	if not shoot_cooldown.is_stopped():
		return
	if bullets_remaining < bullets_per_shot:
		bullets_remaining = 0
		return
	
	var game := get_tree().current_scene
	var projectile := PROJECTILE_SCENE.instantiate() as Projectile
	projectile.direction = Vector2.RIGHT
	projectile.modulate = Color("00ff17")
	projectile.set_collision_mask_enemy()
	game.add_child(projectile)
	
	var spawn_pos: Node2D
	var barrel: Node2D
	if alternate_counter:
		spawn_pos = top_projectile_spawn_position
		barrel = top_barrel
	else:
		spawn_pos = bottom_projectile_spawn_position
		barrel = bottom_barrel
	projectile.global_position = spawn_pos.global_position
	barrel.scale.y = 0.85
	alternate_counter = not alternate_counter
	shoot_sfx.play()
	shoot_cooldown.start()
	bullets_remaining -= bullets_per_shot


# Damage player (destroy)
func hit() -> void:
	destroyed.emit()
	queue_free()


func _update_ammo_display() -> void:
	var ratio := float(bullets_remaining) / float(max_bullets)
	ammo_display.scale = Vector2.ONE * ratio
