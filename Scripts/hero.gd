extends KinematicBody2D

const WALK_SPEED = 5
signal spawn_text(text, position, color)

var life = 100
var color = Color.lightskyblue
var target = Vector2()
var damage = 5

func _ready():
	connect("spawn_text", self.get_parent(), "create_label")
	$AttackTimer.paused = false
	$AttackTimer.start()

func _process(delta):
	# UI
	$HealthBar.value = life

func hit(damage):
	life = max(0, life - damage)
	if life <= 0:
		die()

func die():
	$AnimatedSprite.animation = "dead"

func get_random_alive_target(group_name):
	var nodes = get_tree().get_nodes_in_group(group_name)
	var target_array = []

	# look through spawn nodes to see if any are alive
	for node in nodes:
		if node.life > 0:
			target_array.append(node)
	
	if target_array.size() == 0:
		return null
	
	return target_array[randi() % target_array.size()]

func _on_AttackTimer_timeout():
	$AnimationPlayer.play("action")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "action":
		var aim = get_random_alive_target("monster")
		aim.hit(damage)
