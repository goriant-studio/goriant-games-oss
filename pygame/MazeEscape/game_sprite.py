# gamesprite.py
import pygame

class GameSprite(pygame.sprite.Sprite):
    def __init__(self, x, y, speed, img, w, h):
        super().__init__()
        self.image = pygame.transform.scale(img, (w, h))
        self.rect = self.image.get_rect(topleft=(x, y))

        self.x = x
        self.y = y
        self.speed = speed

    def draw(self, screen):
        screen.blit(self.image, self.rect)
