extends KinematicBody2D

const WALK_SPEED = 5

var life = 100
var color = Color.lightskyblue
var target = Vector2()
var damage = 5
var hit_texts = ["ouch !", "I think my arm is broken", "I'm not paid enought for this"]
var heal_texts = ["at last", "thx mate", "keep up"]
var rez_texts = ["On the road again", "Never gonna give you up", "Stayin' alive"]

func _ready():
	$text.modulate = color

func _process(delta):
	# UI
	$HealthBar.value = life

func hit(damage):
	life = max(0, life - damage)
	if life <= 0:
		die()
		return true
	$ShaderAnimationPlayer.play("hit")
	if randi()%100 < 15:
		var text = hit_texts[randi()%hit_texts.size()]
		print_debug(text)
		speak(text)

func heal(damage):
	if life <= 0:
		return
	life = min(life + damage, 100)
	if randi()%100 < 25:
		speak(hit_texts[randi()%heal_texts.size()])

func resurrect(damage):
	if life <= 0:
		life = damage
		$AnimatedSprite.animation = "running"
		$AttackTimer.stop()
	speak(rez_texts[randi()%rez_texts.size()])

func die():
	$AnimatedSprite.animation = "dead"
	$AttackTimer.stop()

func speak(text : String):
	$text.text = text
	align_text()
	$text/TextTimer.start()

func align_text():
	$text.rect_size.x = $text.get_font("normal_font").get_string_size($text.text).x
	$text.rect_position.x = - $text.rect_size.x / 2

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
		if aim != null:
			aim.hit(damage)

func _on_TextTimer_timeout():
	$text.text = ""

func pause():
	$text/TextTimer.stop()
	$AnimatedSprite.playing = false
	$AnimationPlayer.stop(false)
	$ShaderAnimationPlayer.stop(false)

func unpause():
	$text/TextTimer.start()
	$AnimatedSprite.playing = true
	$AnimationPlayer.play()
	$ShaderAnimationPlayer.play()
