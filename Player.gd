extends CharacterBody2D

@export_range(0, 10.0) var move_speed_modifier: float = 1
@export_range(0, 10.0) var jump_height_modifier: float = 1
var move_speed = 400
var jump_height = 800
@export var gravity: int = 2000

@export_range(0, 1.0) var friction: float = 0.95
@export_range(0, 1.0) var acceleration: float = 0.95
@export_range(0, 5.0) var gravity_divisor: float = 2
@export var coyote_time: int = 10
@export var jump_buffer: int = 10

var coyote_timer = 0
var jump_buffer_timer = 0
var increased_gravity = false

func get_horizontal_movement():
	var dir = 0
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerpf(velocity.x, dir * move_speed * move_speed_modifier, acceleration)
	else:
		velocity.x = lerpf(velocity.x, 0, friction)

func can_jump():
	return is_on_floor() or coyote_timer != 0

func wants_to_jump():
	if jump_buffer_timer != 0:
		jump_buffer_timer = 0
		increased_gravity = false
		return true
	return false

func jump():
	velocity.y -= jump_height * jump_height_modifier

func apply_gravity(delta):
	if increased_gravity:
		velocity.y += gravity * gravity_divisor * delta
	else:
		velocity.y += gravity * delta


func check_coyote_timer():
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= 1
	if coyote_timer < 0:
		coyote_timer = 0

func check_jump_buffer():
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer
	else:
		jump_buffer_timer -= 1
	if jump_buffer_timer < 0:
		jump_buffer_timer = 0

func _physics_process(delta):
	get_horizontal_movement()
	check_coyote_timer()
	check_jump_buffer()
	if Input.is_action_just_released("jump") and velocity.y < -100:
		increased_gravity = true
	elif velocity.y > 0:
		increased_gravity = true
	apply_gravity(delta)
	if can_jump() and wants_to_jump():
		coyote_timer = 0
		jump_buffer_timer = 0
		jump()
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	velocity = velocity
