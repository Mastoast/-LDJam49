extends "res://Scripts/hero.gd"

var fireball = preload("res://Objects/Fireball.tscn")

func _ready():
	color = Color.lightskyblue
	damage = 15
	._ready()

func _process(delta):
	pass

func shoot():
	emit_signal("spawn_text", "BOOM !", self.position, self.color)
	$AnimatedSprite.play("attacking")
	var new_ball = fireball.instance()
	get_parent().add_child(new_ball)
	new_ball.global_position = $SpellPosition.global_position
	new_ball.velocity = self.position.direction_to(target) * 9
