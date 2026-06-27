extends Node

@export var enemyScene: PackedScene
@export var contractScene: PackedScene
@export var player: BulletHellPlayer
@export var spawnerLocations: Array[Node2D]
@export var waves: Array[int]

var currentWave: int = 0
var enemiesSpawned: int = 0
var enemiesKilled: int = 0
var enemies: Array[BulletHellEnemy]

func _ready() -> void:
	startWave()


func getNewEnemy()->BulletHellEnemy:
	for enemy in enemies:
		if enemy.isDisabled():
			return enemy

	var new_enemy = enemyScene.instantiate()
	new_enemy.enemyKilled.connect(onEnemyKilled)
	get_node("/root/BulletHellMinigame").add_child(new_enemy)
	enemies.append(new_enemy)
	return new_enemy

func onEnemyKilled(enemy:BulletHellEnemy)->void:
	SoundPool.stop_sound(SoundPool.AUDIENCE_LAUGH_1, 5.0)
	SoundPool.stop_sound(SoundPool.AUDIENCE_LAUGH_2, 5.0)
	enemiesKilled+=1
	if enemiesKilled==waves[currentWave]:
		currentWave+=1
		if currentWave>=waves.size():
			#drop contract
			var contract = contractScene.instantiate()
			get_node("/root/BulletHellMinigame").call_deferred("add_child",contract)
			contract.position = enemy.position
			return
		$WaveDelay.start()
		
func startWave()->void:
	enemiesSpawned = 0 
	enemiesKilled = 0
	%Wave_Counter.text = "Wave: "+ str(currentWave+1)
	$SpawnCooldown.start()

func spawnEnemy()->void:
	if enemiesSpawned < waves[currentWave]:
		var i = RandUtils.randi_range(0,spawnerLocations.size()-1)
		var spawnPos = spawnerLocations[i].position
		getNewEnemy().spawn(spawnPos,player)
		enemiesSpawned+=1
		$SpawnCooldown.start()
		SoundPool.play_random_sound(SoundPool.ZOMBIE_GROWL)
