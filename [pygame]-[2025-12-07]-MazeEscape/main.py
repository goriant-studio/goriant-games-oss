from pygame import *
import sys

from settings import *
from player import Player
from enemy import Enemy

init()
mixer.init()

# -------------------------
# MAZE
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
display.set_caption("Maze Game - OOP Version")
clock = time.Clock()

# -------------------------
# SOUND
# -------------------------
mixer.music.load("assets/scary.mp3")
mixer.music.play(-1)

hit_sfx = mixer.Sound("assets/enemy-hit.wav")
won_sfx = mixer.Sound("assets/won.wav")

# -------------------------
# ASSETS
# -------------------------
bg = transform.scale(image.load("assets/forest.jpg"), (WIDTH, HEIGHT))

player_img = transform.scale(image.load("assets/main.png"), (PLAYER_SIZE, PLAYER_SIZE))

enemy_img  = transform.scale(image.load("assets/enemy.png"),  (PLAYER_SIZE, PLAYER_SIZE))
enemy_img1 = transform.scale(image.load("assets/enemy1.png"), (PLAYER_SIZE, PLAYER_SIZE))
enemy_img2 = transform.scale(image.load("assets/enemy2.png"), (PLAYER_SIZE, PLAYER_SIZE))
enemy_img3 = transform.scale(image.load("assets/enemy3.png"), (PLAYER_SIZE, PLAYER_SIZE))
enemy_img4 = transform.scale(image.load("assets/enemy4.png"), (PLAYER_SIZE, PLAYER_SIZE))

treasure_img = transform.scale(image.load("assets/treasure.png"), (TILE, TILE))

# -------------------------
# PLAYER
# -------------------------
player = Player(TILE * 1, TILE * 1, 4, player_img)

# -------------------------
# ENEMIES
# -------------------------
enemies = [
    Enemy(TILE * 4,  TILE * 3, 2, enemy_img,  WIDTH, HEIGHT, "ngang"),
    Enemy(TILE * 10, TILE * 5, 1, enemy_img1, WIDTH, HEIGHT, "doc"),
    Enemy(TILE * 8,  TILE * 2, 3, enemy_img2, WIDTH, HEIGHT, "doc"),
    Enemy(TILE * 6,  TILE * 10,2, enemy_img3, WIDTH, HEIGHT, "ngang"),
    Enemy(TILE * 2,  TILE * 13,4, enemy_img4, WIDTH, HEIGHT, "ngang"),
]

# -------------------------
# TREASURE
# -------------------------
treasure_rect = Rect(TILE * 13, TILE * 13, TILE, TILE)

# -------------------------
# COLLISION WITH WALL
# -------------------------
def can_move(nx, ny):
    rect = Rect(nx, ny, PLAYER_SIZE, PLAYER_SIZE)
    for r in range(ROWS):
        for c in range(COLS):
            if maze[r][c] == 1:
                if rect.colliderect(Rect(c*TILE, r*TILE, TILE, TILE)):
                    return False
    return True

# -------------------------
# MAZE DRAW
# -------------------------
def draw_maze():
    for r in range(ROWS):
        for c in range(COLS):
            if maze[r][c] == 1:
                draw.rect(screen, (80,107,77), (c*TILE, r*TILE, TILE, TILE))

# -------------------------
# POPUP
# -------------------------
def show_lose_screen():
    mixer.music.stop()
    font_big = font.Font("assets/roboto.ttf", 64)
    text = font_big.render("Bạn Thua Rồi!!!", True, (255,0,0))

    overlay = Surface((WIDTH, HEIGHT))
    overlay.set_alpha(180)
    overlay.fill((0,0,0))
    screen.blit(overlay, (0,0))

    screen.blit(text, (WIDTH//2 - text.get_width()//2,
                       HEIGHT//2 - text.get_height()//2))
    display.flip()
    time.delay(3000)
    sys.exit()

def show_won_screen():
    mixer.music.stop()
    won_sfx.play()

    font_big = font.Font("assets/roboto.ttf", 64)

    lines = ["CHÚC MỪNG BẠN ĐÃ CHIẾN THẮNG", "YEAH YEA!!!"]
    y_start = HEIGHT//2 - 80

    overlay = Surface((WIDTH, HEIGHT))
    overlay.set_alpha(180)
    overlay.fill((0,0,0))
    screen.blit(overlay, (0,0))

    for i, line in enumerate(lines):
        surf = font_big.render(line, True, (255,215,0))
        screen.blit(surf, (WIDTH//2 - surf.get_width()//2, y_start + i*70))

    display.flip()
    time.delay(3000)
    sys.exit()

# -------------------------
# GAME LOOP
# -------------------------
while True:
    for e in event.get():
        if e.type == QUIT:
            sys.exit()

    keys = key.get_pressed()
    player.move(keys, can_move)

    for en in enemies:
        en.update()
        if player.rect.colliderect(en.rect):
            hit_sfx.play()
            show_lose_screen()

    if player.rect.colliderect(treasure_rect):
        show_won_screen()

    screen.blit(bg, (0,0))
    draw_maze()
    player.draw(screen)

    for en in enemies:
        en.draw(screen)

    screen.blit(treasure_img, treasure_rect)
    display.flip()
    clock.tick(FPS)
