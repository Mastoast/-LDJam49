extends CPUParticles2D


func _ready():
	self.emitting = true
	
func _process(delta):
	if !self.emitting:
		queue_free()
