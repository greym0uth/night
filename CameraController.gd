extends Camera3D

const Photo = preload("res://inventory/Photo.gd")
const PhotoInventory = preload("res://inventory/PhotoInventory.gd")

signal photo_captured(photo: Photo)

@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0

@export var image_card_size: int = 600
@export var image_card_padding: int = 20

@export var photo_inventory_path: NodePath = "../PhotoInventory"
@onready var photo_inventory: PhotoInventory = get_node(photo_inventory_path)

var mouse_axis := Vector2()
var rot := Vector3()

var objects = Dictionary()

# func _prune_objects():
#   for key in objects:
#     if !is_instance_id_valid(key) || instance_from_id(key).is_queued_for_deletion() == null:
#       objects.erase(key)

func _get_distance_score(position: Vector2, center: Vector2) -> float:
  var distance = center.distance_squared_to(position)
  return 1.0 - (distance / 90000.0)

func get_centroid(vectors: Array) -> Vector2:
  var sum = vectors.reduce(func(acc: Vector2, i: Vector2) -> Vector2: return acc + i, Vector2.ZERO)
  return sum / (vectors.size() as float)

func snap():
  var viewport_center = Vector2(get_viewport().get_visible_rect().get_center())

  var count = objects.size() as float
  var positions = objects.values().map(func(obj: Node3D) -> Vector2: return unproject_position(obj.position))
  var distance_score = _get_distance_score(get_centroid(positions), viewport_center)

  var snapshot = get_viewport().get_texture().get_image()
  var snapshot_width = snapshot.get_width()
  var snapshot_height = snapshot.get_height()
  var inner_size = image_card_size - image_card_padding * 2
  var snapshot_center = Rect2i((snapshot_width / 2) - (inner_size / 2), (snapshot_height / 2) - (inner_size / 2), inner_size, inner_size)

  var card = Image.new()
  card.create(600, 700, false, Image.FORMAT_RGB8)
  card.fill(Color.WHITE)
  card.blit_rect(snapshot, snapshot_center, Vector2i(1, 1) * image_card_padding)
  var image_texture = ImageTexture.create_from_image(card)
  var photo = Photo.new("res://test.png", image_texture)
  open_photo(photo, false)
  
func open_photo(photo: Photo, reopened = true):
  $PhotoPreview.open(photo, reopened)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  mouse_sensitivity = mouse_sensitivity / 1000
  y_limit = deg_to_rad(y_limit)

func _process(_delta):
  if Input.is_action_just_pressed("snap") && photo_inventory.has_space():
    $AnimationPlayer.play("snap")

# Called when there is an input event
func _input(event: InputEvent) -> void:
  # Mouse look (only if the mouse is captured).
  if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
    mouse_axis = event.relative
    camera_rotation()

func camera_rotation() -> void:
  # Horizontal mouse look.
  rot.y += mouse_axis.x * mouse_sensitivity
  # Vertical mouse look.
  rot.x = clamp(rot.x + mouse_axis.y * mouse_sensitivity, -0, y_limit)
  
  rotation.y = rot.y
  rotation.x = rot.x

func _on_area_3d_area_entered(area: Area3D):
  objects[area.get_instance_id()] = area

func _on_area_3d_area_exited(area: Area3D):
  objects.erase(area.get_instance_id())

func _on_photo_preview_photo_saved(photo):
  emit_signal("photo_captured", photo)
