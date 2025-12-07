# player.py
import pygame
from game_sprite import GameSprite
from settings import PLAYER_SIZE

class Player(GameSprite):
    def __init__(self, x, y, speed, img):
        super().__init__(x, y, speed, img, PLAYER_SIZE, PLAYER_SIZE)

    def move(self, keys, can_move_func):
        new_x = self.x
        new_y = self.y

        if keys[pygame.K_LEFT] or keys[pygame.K_a]:
            new_x -= self.speed
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]:
            new_x += self.speed
        if keys[pygame.K_UP] or keys[pygame.K_w]:
            new_y -= self.speed
        if keys[pygame.K_DOWN] or keys[pygame.K_s]:
            new_y += self.speed

        if can_move_func(new_x, self.y):
            self.x = new_x
        if can_move_func(self.x, new_y):
            self.y = new_y

        self.rect.topleft = (self.x, self.y)
