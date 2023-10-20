extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 1500.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doingAction = false
var last_direction = 1

@onready var anim = get_node("AnimationPlayer")
@onready var action_timer = Timer.new()

func _ready():
	add_child(action_timer)
	action_timer.wait_time = 1
	action_timer.one_shot = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("move_left", "move_right")
	if direction == -1 && doingAction == false:
		last_direction = -1
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1 && doingAction == false:
		last_direction = 1
		get_node("AnimatedSprite2D").flip_h = false
	if direction && doingAction == false:
		if velocity.y == 0:
			anim.set_speed_scale(1)
			anim.play("Run")
		velocity.x = direction * SPEED
	else:
		if velocity.y == 0 && doingAction == false:
			anim.set_speed_scale(1)
			anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("dash"):
		if doingAction == false:
			doingAction = true
			anim.set_speed_scale(4)
			anim.play("Dash")
			velocity.x = last_direction * DASH_SPEED
			move_and_slide()
		
	if Input.is_action_just_pressed("attack"):
		if doingAction == false:
			doingAction = true
			anim.set_speed_scale(3)
			anim.play("Attack1")
			move_and_slide()
		
	move_and_slide()

func _on_animation_player_animation_finished(Dash):
	doingAction = false
