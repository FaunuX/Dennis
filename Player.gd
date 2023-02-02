extends KinematicBody2D

export (int) var move_speed = 400
export (int) var jump_height = 1000
export (int) var gravity = 2000

export (float, 0, 1.0) var friction = 0.9
export (float, 0, 1.0) var acceleration = 0.1
export var gravity_divisor = 2
export var coyote_time = 10
export var jump_buffer = 10

var velocity = Vector2.ZERO
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
		velocity.x = lerp(velocity.x, dir * move_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func can_jump():
	return is_on_floor() or coyote_timer != 0

func wants_to_jump():
	if jump_buffer_timer != 0:
		jump_buffer_timer = 0
		increased_gravity = false
		return true
	return false

func jump():
	velocity.y -= jump_height

func apply_gravity(delta):
	if increased_gravity:
		velocity.y += gravity * gravity_divisor * delta
	else:
		velocity.y += gravity * delta

func move():
	velocity = move_and_slide(velocity, Vector2.UP)

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
#func on_ground():
#	return is_on_floor() or coyote_timer != 0

#func jump():
#	velocity.y = jump_speed

#func apply_gravity(strong, delta):
#	if strong:
#		velocity.y += gravity * delta
#	else:
#		velocity.y += (gravity/3) * delta

func _physics_process(delta):
	get_horizontal_movement()
	check_coyote_timer()
	check_jump_buffer()
	print(coyote_timer, jump_buffer)
	if Input.is_action_just_released("jump") and velocity.y < -100:
		increased_gravity = true
	elif velocity.y > 0:
		increased_gravity = true
	apply_gravity(delta)
	if can_jump() and wants_to_jump():
		jump()
	move()
