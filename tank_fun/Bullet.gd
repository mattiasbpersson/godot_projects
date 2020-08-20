extends KinematicBody2D

export (PackedScene) var Explosion

var speed = 750
var velocity = Vector2()
var exploding = false

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	if(exploding):
		return		
	var collision = move_and_collide(velocity * delta)
	if collision:
		#print("I collided with ", collision.collider.name)
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
		else:
			explode(position)
			velocity = Vector2.ZERO
			exploding = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func explode(hit_position):
	$Sprite.hide()
	$ExplosionSound.play()
	$Explosion.show()
	$Explosion.play("explode")



func _on_Explosion_animation_finished():
	$ExplosionSound.stop()
	queue_free()
	
