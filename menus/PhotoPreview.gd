extends CanvasLayer

const Photo = preload("res://inventory/Photo.gd")

signal close
signal photo_saved(photo: Photo)

var photo: Photo
var should_call_save = true

func save():
#  photo.image_texture.get_image().save_png("res://test.png")
  close_preview()
  if should_call_save:
    emit_signal("photo_saved", photo)

func open(photo: Photo, reopened = false):
  self.photo = photo
  self.should_call_save = !reopened
  get_tree().paused = true
  $SnapPreview.texture = photo.image_texture
  $AnimationPlayer.play("open")

func close_preview():
  $AnimationPlayer.play("close")
  get_tree().paused = false
  emit_signal("close")
