extends Node2D

enum DustState {SPAWNING_PARTICLES, STOPPING, NO_PARTICLES}
var current_state : DustState = DustState.NO_PARTICLES

#Export Variables
@export var darkest_dust: CPUParticles2D
@export var  mid_dust: CPUParticles2D
@export var lightest_dust: CPUParticles2D

#RPG Range for the dust particles
@export var min_particles: int = 5
@export var max_particles: int = 15

#Tracking when particles die
var max_lifetime: float = 0.0
var stop_timer: float = 0.0

func _ready() -> void:
	#Start hidden
	visible = false
	current_state = DustState.NO_PARTICLES
	
	if darkest_dust: max_lifetime = max(max_lifetime,darkest_dust.lifetime)
	if mid_dust: max_lifetime = max(max_lifetime,mid_dust.lifetime)
	if lightest_dust: max_lifetime = max(max_lifetime,lightest_dust.lifetime)
	
	
func _process(delta: float) -> void:
	#Count time only during the stop state
	if current_state == DustState.STOPPING:
		stop_timer += delta
		
		if stop_timer >= max_lifetime:
			_on_no_particles_alive()
		
func _on_player_start_moving() -> void:
	if current_state == DustState.SPAWNING_PARTICLES:
		return
		
	current_state = DustState.SPAWNING_PARTICLES
	visible = true
	stop_timer = 0.0
		
	_randomize_and_play(darkest_dust)
	_randomize_and_play(mid_dust)
	_randomize_and_play(lightest_dust)
		
func _on_player_stop_moving() -> void:
	if current_state == DustState.SPAWNING_PARTICLES:
		current_state = DustState.STOPPING
		
		if darkest_dust: darkest_dust.emitting = false
		if mid_dust: mid_dust.emitting = false
		if lightest_dust: lightest_dust.emitting = false
		
func _on_no_particles_alive() -> void:
	current_state = DustState.NO_PARTICLES
	visible = false
	
func _randomize_and_play(particle_system: CPUParticles2D) -> void:
	if particle_system:
		particle_system.amount = randi_range(min_particles,max_particles)
		particle_system.emitting = true					
