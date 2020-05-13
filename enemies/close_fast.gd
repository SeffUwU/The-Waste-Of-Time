extends KinematicBody2D

var Player
#direction to player or target
var targetDir = Vector2()
var imTooClose = false

export var moveSpeed = 80
#current speed vector
var currentSpeed = Vector2()


func _physics_process(delta):
	if Player != null:
		targetDir.x = Player.position.x - self.position.x
		targetDir.y = Player.position.y - self.position.y
		if imTooClose == true:
			targetDir = lerp(targetDir,-targetDir, 0.6)
		currentSpeed = move_and_slide(moveSpeed * targetDir * delta,Vector2(0,-1))
	print(targetDir.normalized())




func _on_TargetZone_body_entered(body):
	if body.name == "Player":
		Player = body


func _on_TargetZone_body_exited(body):
	if body.name == "Player":
		Player = null


func _on_tooClose_body_entered(body):
	if body.name == "Player":
		imTooClose = true


func _on_tooClose_body_exited(body):
	if body.name == "Player":
		imTooClose = false

