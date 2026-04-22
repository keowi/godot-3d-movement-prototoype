extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $AnimationPlayer

# Hareket hızı
var speed = 2.0
# Masaya ne kadar yaklaşınca "vardım" saysın? (Örn: 1 metre)
var stop_distance = 1.0

var target_table = null
var is_sitting = false

func _ready():
	# Oyun başlar başlamaz en yakın masayı ara
	find_nearest_table()

func find_nearest_table():
	# "tables" grubundaki tüm objeleri listele
	var all_tables = get_tree().get_nodes_in_group("tables")
	
	var min_distance = INF # Sonsuz uzaklık başlat
	var closest = null
	
	for table in all_tables:
		# Mesafeyi ölç
		var dist = global_position.distance_to(table.global_position)
		
		# Eğer bu masa şu ana kadar bulduğumdan daha yakınsa, yeni hedef bu
		if dist < min_distance:
			min_distance = dist
			closest = table
	
	if closest:
		target_table = closest
		# Navigasyon ajanına hedefi bildir
		nav_agent.target_position = target_table.global_position
		print("Hedef belirlendi: ", target_table.name)

func _physics_process(delta):
	# Eğer oturuyorsak veya hedef yoksa hareket etme
	if is_sitting or target_table == null:
		return

	# Hedefe vardık mı kontrolü
	if nav_agent.is_navigation_finished():
		sit_down()
		return

	# --- HAREKET MANTIĞI ---
	
	# Bir sonraki adımın pozisyonunu al
	var next_path_position = nav_agent.get_next_path_position()
	# O yöne doğru vektör oluştur
	var direction = global_position.direction_to(next_path_position)
	
	# Yüzünü gittiği yöne dön (Y ekseninde)
	look_at(Vector3(next_path_position.x, global_position.y, next_path_position.z), Vector3.UP)
	
	# Hızı uygula
	velocity = direction * speed
	move_and_slide()
	
	# Animasyonu oynat
	anim_player.play("walk")

func sit_down():
	is_sitting = true
	velocity = Vector3.ZERO # Kaymayı önle
	
	# Masaya tam dönmek istersen:
	if target_table:
		look_at(Vector3(target_table.global_position.x, global_position.y, target_table.global_position.z), Vector3.UP)
	
	anim_player.play("sit")
	print("Masaya vardı ve oturdu.")
