extends "res://Scripts/hero.gd"

var fireball = preload("res://Objects/Fireball.tscn")

func _ready():
	color = Color.lightskyblue

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

func shoot():
	$AnimatedSprite.play("attacking")
	var new_ball = fireball.instance()
	get_parent().add_child(new_ball)
	new_ball.global_position = $SpellPosition.global_position
	new_ball.velocity = self.position.direction_to(target) * 9
