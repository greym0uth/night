extends Node3D

@export var meteor_scene: PackedScene

@export var spawn_frequency = 10.0
@export var spawn_distance = 200.0
@export var propagation_decay = 0.25
@export var propagation_range = PI / 16

var rng = RandomNumberGenerator.new()

func _rand_progation_range() -> float:
  return clampf(pow(rng.randf_range(-1, 1), 1.0 / 5.0), -propagation_range, propagation_range)

func _spawn_meteor(position: Vector3, rotation: Quaternion, propagate_chance: float):
  if meteor_scene:
    var meteor: Node3D = meteor_scene.instantiate()
    meteor.position = position
    meteor.quaternion = rotation
    $Meteors.add_child(meteor)

    # Provide a chance to spawn another meteor with an even smaller chance of propagating again
    if rng.randf() < propagate_chance:
      var offset = Vector3(rng.randf_range(-30.0, 30.0), rng.randf_range(-10.0, 10), rng.randf_range(-30.0, 30.0))
      _spawn_meteor(position + offset, rotation, propagate_chance * propagation_decay)

func _ready():
  $Timer.start(spawn_frequency)

func _on_timer_timeout():
  var rand_x = rng.randf_range(-1, 1)
  var z_limit = 1 - abs(rand_x)
  var rand_z = rng.randf_range(-z_limit, z_limit)
  var position = Vector3(rand_x, 0.0, rand_z)
  position.y = clamp(sqrt(1 - position.length_squared()), 0.02, 1)
  
  _spawn_meteor(position * spawn_distance, Quaternion(Vector3.UP, rng.randf_range(0, TAU)), 1.0)
