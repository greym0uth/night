extends CanvasLayer

const Photo = preload("res://inventory/Photo.gd")

signal photo_opened(photo: Photo)

@export var photo_inventory_item: PackedScene
@export var max_size: int = 5

var open = false

@onready var container = get_node("MarginContainer/VBoxContainer/HBoxContainer")

func add(photo: Photo):
  if photo_inventory_item:
    var item = photo_inventory_item.instantiate() as TextureButton
    item.texture_normal = photo.image_texture
    item.data = photo
    item.connect("pressed", func(): open_photo(photo))
    container.add_child(item)

func size() -> int:
  return container.get_child_count()

func has_space() -> bool:
  return size() < max_size

func get_all() -> Array:
  return container.get_children().map(func(child) -> Photo: return child.data)

func open_photo(photo: Photo):
  emit_signal("photo_opened", photo)

func _on_hover():
  $HoverDebounce.stop()
  if !open:
    open = true
    $AnimationPlayer.play("space")

func _on_hover_end():
  $HoverDebounce.start(1.5)

func _collapse():
  $AnimationPlayer.play_backwards("space")
  open = false
