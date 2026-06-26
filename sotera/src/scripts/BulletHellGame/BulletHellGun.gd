extends Node2D
class_name BulletHellGun


@export var bulletScene: PackedScene
@export var firerate: float

@onready var fire_rate: Timer = $FireRate

var preloadedBullets: Array[BulletHellBullet]

func shoot(mouse_pos: Vector2):
	if fire_rate.is_stopped():
		getBullet().shoot(mouse_pos)
		fire_rate.start(1.0 / firerate)
		SoundPool.play_sound(SoundPool.KNIFE_SHING)


func getBullet() -> BulletHellBullet:
	for bullet in preloadedBullets:
		if bullet.state == BulletHellBullet.BULLETSTATE.DISABLED:
			bullet.position = global_position
			return bullet

	var new_bullet = bulletScene.instantiate()
	new_bullet.position = global_position
	get_node("/root/BulletHellMinigame").add_child(new_bullet)
	preloadedBullets.append(new_bullet)
	return new_bullet
