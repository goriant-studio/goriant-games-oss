# enemy.py
from pygame import *
from settings import PLAYER_SIZE, TILE

class Enemy:
    def __init__(self, x, y, speed, img, width, height, mode="ngang"):
        self.x = x
        self.y = y
        self.speed = speed
        self.dir = 1
        self.img = img
        self.width = width
        self.height = height
        self.mode = mode   # "ngang" hoặc "doc"
        self.rect = Rect(x, y, PLAYER_SIZE, PLAYER_SIZE)

    def update(self):
        if self.mode == "ngang":
            # enemy di chuyển trái-phải
            self.x += self.speed * self.dir

            if self.x < TILE or self.x > self.width - TILE - PLAYER_SIZE:
                self.dir *= -1

        elif self.mode == "doc":
            # enemy di chuyển lên-xuống
            self.y += self.speed * self.dir

            if self.y < TILE or self.y > self.height - TILE - PLAYER_SIZE:
                self.dir *= -1

        self.rect.topleft = (self.x, self.y)

    def draw(self, screen):
        screen.blit(self.img, (self.x, self.y))
