extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var doingAction = false

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
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
		doingAction = true
		anim.set_speed_scale(3)
		anim.play("Dash")
		if doingAction == true:
			velocity.x = direction * SPEED
			print("OK")
		get_tree().create_timer(1)
		
	if Input.is_action_just_pressed("attack"):
		doingAction = true
		anim.set_speed_scale(3)
		anim.play("Attack1")
		get_tree().create_timer(1)
		
	move_and_slide()


func _on_animation_player_animation_finished(Dash):
	doingAction = false # Replace with function body.
