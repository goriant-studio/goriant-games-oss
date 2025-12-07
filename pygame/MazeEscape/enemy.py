# enemy.py
import pygame
from game_sprite import GameSprite
from settings import PLAYER_SIZE, TILE

class Enemy(GameSprite):
    def __init__(self, x, y, speed, img, width, height, mode="ngang"):
        super().__init__(x, y, speed, img, PLAYER_SIZE, PLAYER_SIZE)

        self.width = width
        self.height = height
        self.mode = mode
        self.dir = 1

    def update(self):
        if self.mode == "ngang":
            self.x += self.speed * self.dir

            if self.x < TILE or self.x > self.width - TILE - PLAYER_SIZE:
                self.dir *= -1

        elif self.mode == "doc":
            self.y += self.speed * self.dir

            if self.y < TILE or self.y > self.height - TILE - PLAYER_SIZE:
                self.dir *= -1

        self.rect.topleft = (self.x, self.y)
