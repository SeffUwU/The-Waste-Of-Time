extends RigidBody2D

var Player
#direction to player or target
var targetDir = Vector2()


export var moveSpeed = 80
#current speed vector
var currentSpeed = Vector2()


func _physics_process(delta):
	if Player != null:
		targetDir.x = Player.position.x - self.position.x
		targetDir.y = Player.position.y - self.position.y
		currentSpeed = add_force(targetDir * moveSpeed * delta, targetDir)
	print(targetDir.normalized())




func _on_TargetZone_body_entered(body):
	if body.name == "Player":
		Player = body


func _on_TargetZone_body_exited(body):
	if body.name == "Player":
		Player = null
