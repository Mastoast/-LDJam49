extends KinematicBody2D

const WALK_SPEED = 5
signal spawn_text(text, position, color)

var life = 100
var velocity = Vector2()
var is_attacking = false
var color = Color.lightskyblue
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("spawn_text", self.get_parent(), "create_label")

func _process(delta):
#	else:
#		$AttackCooldown.stop()
#		is_attacking = false
	
	# UI
	$HealthBar.value = life
	
	if life <= 0:
		$AnimatedSprite.animation = "dead"
		return
	elif is_attacking:
		$AnimatedSprite.animation = "attacking"
	elif velocity == Vector2.ZERO:
		$AnimatedSprite.animation = "idle"
	else:
		$AnimatedSprite.animation = "running"

	if velocity.x > 0:
		scale.x = 1
		#$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		scale.x = -1
		#$AnimatedSprite.flip_h = true

func _physics_process(delta):
	if is_attacking or life <= 0 or target == Vector2.ZERO:
		return
	if target.x < self.get_global_transform().get_origin().x:
		velocity.x = -WALK_SPEED
	elif target.x > self.get_global_transform().get_origin().x:
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
		
	if target.y > get_global_transform().get_origin().y:
		velocity.y = WALK_SPEED
	elif target.y < get_global_transform().get_origin().y:
		velocity.y =  -WALK_SPEED
	else:
		velocity.y = 0
	
	move_and_collide(velocity)

func get_nearest_node_in_group(group_name):
	var nodes = get_tree().get_nodes_in_group(group_name)

	var nearest_node = nodes[0]

	# look through spawn nodes to see if any are closer
	for node in nodes:
		if node.global_position.distance_to(global_position) < nearest_node.global_position.distance_to(global_position):
			nearest_node = node
	return nearest_node

	#emit_signal("spawn_text", )

func hit(damage):
	life = max(0, life - damage)
	if life <= 0:
		$AnimatedSprite.animation = "dead"

func _on_hit_zone_body_entered(body):
	if body.is_in_group("monster"):
		is_attacking = true


func _on_hit_zone_body_exited(body):
	if body.is_in_group("monster"):
		var bodies = $HitZone.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("monster"):
				return
		is_attacking = false
