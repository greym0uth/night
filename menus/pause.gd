extends CanvasLayer

func unpause():
  get_tree().paused = false
  $AnimationPlayer.play_backwards("pause")

func pause():
  get_tree().paused = true
  $AnimationPlayer.play("pause")

func _ready():
  pause()
