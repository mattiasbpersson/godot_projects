extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")
var speed = 200
var friction = 0.05
var acceleration = 0.1
var velocity = Vector2.ZERO
	
func _ready():
	$Exhaust.show()

func get_input():
	# Add these actions in Project Settings -> Input Map.
	var input_velocity = Vector2.ZERO
	if Input.is_action_pressed('backward'):
		input_velocity = Vector2(-1, 0).rotated(rotation)
	if Input.is_action_pressed('forward'):
		input_velocity = Vector2(1, 0).rotated(rotation)
		
	if Input.is_action_just_pressed('click'):
		shoot()
	input_velocity = input_velocity.normalized() * speed
	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)

func shoot():
	# "Muzzle" is a Position2D placed at the barrel of the gun.
	var b = Bullet.instance()
	b.start($Muzzle.global_position, rotation)
	get_parent().add_child(b)
	var backwards = velocity.rotated(PI)
	rotate(rand_range(-PI / 2, PI / 2))
	velocity = velocity.linear_interpolate(backwards, 1)
	$GunSmoke.restart()
	$TankFiring.play()
	

func _physics_process(delta):
	get_input()
	
	var dir = get_global_mouse_position() - global_position
	# Don't move if too close to the mouse pointer.
	if dir.length() > 5:
		rotation = dir.angle()
		velocity = move_and_slide(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
