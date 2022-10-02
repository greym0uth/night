extends CanvasLayer

const Photo = preload("res://inventory/Photo.gd")

signal close
signal photo_saved(photo: Photo)

var photo: Photo
var should_call_save = true

func save():

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

func export():
  var regex = RegEx.new()
  regex.compile("^[a-zA-Z0-9](?:[a-zA-Z0-9 ._-]*[a-zA-Z0-9])?$")
  var filename: String = $Export/MarginContainer/VBoxContainer2/Filename.text
  if filename.length() > 0 && regex.search(filename):
    photo.image_texture.get_image().save_jpg("./" + filename + ".jpg", 1)
    $AnimationPlayer.play("export_done")
  else:
    $Export/MarginContainer/VBoxContainer2/Error.show()
