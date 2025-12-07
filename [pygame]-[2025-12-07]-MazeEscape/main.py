from pygame import *
from settings import *
from enemy import Enemy
import sys

init()
mixer.init()

# -------------------------
# MAZE (1 = wall, 0 = đường)
# -------------------------
maze = [
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,1,0,0,0,0,1,0,0,0,0,1],
    [1,0,1,0,1,0,1,1,0,1,0,1,1,0,1],
    [1,0,1,0,0,0,1,0,0,0,0,1,0,0,1],
    [1,0,1,1,1,0,1,0,1,1,1,1,0,1,1],
    [1,0,0,0,1,0,0,0,0,0,1,0,0,0,1],
    [1,1,1,0,1,1,1,1,1,0,1,1,1,0,1],
    [1,0,0,0,0,0,0,0,1,0,0,0,1,0,1],
    [1,0,1,1,1,1,1,0,1,1,1,0,1,0,1],
    [1,0,1,0,0,0,1,0,0,0,0,0,1,0,1],
    [1,0,1,0,1,0,1,1,1,1,1,0,1,0,1],
    [1,0,0,0,1,0,0,0,0,0,1,0,1,0,1],
    [1,1,1,0,1,1,1,1,1,0,1,1,1,0,1],
    [1,0,0,0,0,0,0,0,1,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
]

ROWS = len(maze)
COLS = len(maze[0])
WIDTH  = COLS * TILE
HEIGHT = ROWS * TILE

screen = display.set_mode((WIDTH, HEIGHT))
display.set_caption("Maze Game - Pygame")
clock = time.Clock()

# -------------------------
# MUSIC & SOUND
# -------------------------
mixer.music.load("assets/scary.mp3")
mixer.music.set_volume(0.5)
mixer.music.play(-1)

hit_sfx = mixer.Sound("assets/enemy-hit.wav")
hit_sfx.set_volume(0.7)

won_sfx = mixer.Sound("assets/won.wav")
won_sfx.set_volume(0.7)

# -------------------------
# COLORS
# -------------------------
WALL_COLOR = (80, 107, 77)  # deep moss green
FLOOR_COLOR = (30, 30, 40)

# -------------------------
# LOAD ASSETS
# -------------------------
bg = image.load("assets/forest.jpg").convert()
bg = transform.scale(bg, (WIDTH, HEIGHT))

player_img = image.load("assets/main.png").convert_alpha()
player_img = transform.scale(player_img, (PLAYER_SIZE, PLAYER_SIZE))

enemy_img = image.load("assets/enemy.png").convert_alpha()
enemy_img = transform.scale(enemy_img, (PLAYER_SIZE, PLAYER_SIZE))

enemy_img1 = image.load("assets/enemy1.png").convert_alpha()
enemy_img1 = transform.scale(enemy_img1, (PLAYER_SIZE, PLAYER_SIZE))

enemy_img2 = image.load("assets/enemy2.png").convert_alpha()
enemy_img2 = transform.scale(enemy_img2, (PLAYER_SIZE, PLAYER_SIZE))

enemy_img3 = image.load("assets/enemy3.png").convert_alpha()
enemy_img3 = transform.scale(enemy_img3, (PLAYER_SIZE, PLAYER_SIZE))

treasure_img = image.load("assets/treasure.png").convert_alpha()
treasure_img = transform.scale(treasure_img, (TILE, TILE))

# -------------------------
# PLAYER
# -------------------------
player_x = TILE * 1
player_y = TILE * 1
player_speed = 4


# -------------------------
# SPAWN MULTIPLE ENEMIES
# -------------------------
enemies = [
    Enemy(TILE * 4, TILE * 3, 2, enemy_img, WIDTH, HEIGHT, mode="ngang"),
    Enemy(TILE * 10, TILE * 5, 1, enemy_img1, WIDTH, HEIGHT, mode="doc"),
    Enemy(TILE * 8, TILE * 2, 3, enemy_img2, WIDTH, HEIGHT, mode="doc"),
    Enemy(TILE * 6, TILE * 10, 2, enemy_img3, WIDTH, HEIGHT, mode="ngang"),
]


# -------------------------
# TREASURE POSITION
# -------------------------
treasure_x = TILE * 13
treasure_y = TILE * 13


# -------------------------
# COLLISION FUNCTION
# -------------------------
def can_move(new_x, new_y):
    rect = Rect(new_x, new_y, PLAYER_SIZE, PLAYER_SIZE)

    for r in range(ROWS):
        for c in range(COLS):
            if maze[r][c] == 1:
                wall_rect = Rect(c * TILE, r * TILE, TILE, TILE)
                if rect.colliderect(wall_rect):
                    return False
    return True


# -------------------------
# LOSE / WIN POPUP
# -------------------------
def show_lose_screen():
    mixer.music.stop()
    font_big = font.Font("assets/roboto.ttf", 64)
    text = font_big.render("Bạn Thua Rồi!!!", True, (255, 0, 0))

    overlay = Surface((WIDTH, HEIGHT))
    overlay.set_alpha(180)
    overlay.fill((0, 0, 0))
    screen.blit(overlay, (0, 0))

    screen.blit(text, (WIDTH//2 - text.get_width()//2,
                       HEIGHT//2 - text.get_height()//2))

    display.flip()
    time.delay(3000)
    sys.exit()


def show_won_screen():
    mixer.music.stop()
    won_sfx.play()

    font_big = font.Font("assets/roboto.ttf", 64)
    text = font_big.render("CHÚC MỪNG BẠN ĐÃ CHIẾN THẮNG\n YEAH YEA!!!", True, (255, 215, 0))

    overlay = Surface((WIDTH, HEIGHT))
    overlay.set_alpha(180)
    overlay.fill((0, 0, 0))
    screen.blit(overlay, (0, 0))

    screen.blit(text, (WIDTH//2 - text.get_width()//2,
                       HEIGHT//2 - text.get_height()//2))

    display.flip()
    time.delay(3000)
    sys.exit()


# -------------------------
# DRAW MAZE WALLS
# -------------------------
def draw_maze():
    for r in range(ROWS):
        for c in range(COLS):
            if maze[r][c] == 1:
                draw.rect(screen, WALL_COLOR, (c*TILE, r*TILE, TILE, TILE))


# -------------------------
# GAME LOOP
# -------------------------
while True:
    for e in event.get():
        if e.type == QUIT:
            sys.exit()

    keys = key.get_pressed()

    # Tính thử vị trí mới
    new_x = player_x
    new_y = player_y

    if keys[K_LEFT] or keys[K_a]:
        new_x -= player_speed
    if keys[K_RIGHT] or keys[K_d]:
        new_x += player_speed
    if keys[K_UP] or keys[K_w]:
        new_y -= player_speed
    if keys[K_DOWN] or keys[K_s]:
        new_y += player_speed

    # Nếu không đụng tường thì cập nhật vị trí
    if can_move(new_x, player_y):
        player_x = new_x
    if can_move(player_x, new_y):
        player_y = new_y

    player_rect = Rect(player_x, player_y, PLAYER_SIZE, PLAYER_SIZE)

    # UPDATE ENEMIES
    for e_obj in enemies:
        e_obj.update()

        if player_rect.colliderect(e_obj.rect):
            hit_sfx.play()
            show_lose_screen()

    # WIN CHECK
    if player_rect.colliderect(Rect(treasure_x, treasure_y, TILE, TILE)):
        show_won_screen()

    # ---- RENDER ----
    screen.blit(bg, (0, 0))
    draw_maze()
    screen.blit(player_img, (player_x, player_y))

    for e_obj in enemies:
        e_obj.draw(screen)

    screen.blit(treasure_img, (treasure_x, treasure_y))

    display.flip()
    clock.tick(FPS)
