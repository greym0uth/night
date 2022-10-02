extends Area3D

@export var speed = 20.0

func _ready():
  $AnimationPlayer.play("fade")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  position += Vector3(-1, 0, 0) * speed * delta

func _on_animation_player_animation_finished(anim_name: StringName):
  if anim_name == "fade":
    queue_free()
