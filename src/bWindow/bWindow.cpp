
// Bee Bussell
// Sept 1, 2021
// Wraps the SDL window and renderer class together

#include <iostream>

#include "bWindow.h"

bWindow::~bWindow() {

    closeWindow();
}

bool bWindow::createWindow() {

    if (SDL_Init(SDL_INIT_EVERYTHING) == 0) {

        printf("........SDL Successfully Initialized........\n");

        sdlWindow = SDL_CreateWindow(windowTitle, xPos, yPos, width, height, windowFlags);

        if (sdlWindow) {
            SDL_UpdateWindowSurface(sdlWindow);
            printf(".....Window Successfully Initialized........\n");
        } else {
            printf(".....Window Failed to Initialize........\n");
            return false;
        }
        sdlRenderer = SDL_CreateRenderer(sdlWindow, -1, renderFlags);

        if (sdlRenderer) {

            SDL_SetRenderDrawColor(sdlRenderer, 0, 0, 0, 255);
            SDL_RenderClear(sdlRenderer);
            SDL_RenderPresent(sdlRenderer);
            printf("...Renderer Successfully Initialized........\n");
        } else {
            printf("...Renderer Failed to Initialize........\n");
            return false;
        }
    } else {
        printf("........SDL Failed to Initialize........\n");
        return false;
    }
    numOfWindows++;
    return true;
}

void bWindow::closeWindow() {

    numOfWindows--;

    SDL_DestroyWindow(sdlWindow);
    SDL_DestroyRenderer(sdlRenderer);

    if (numOfWindows <= 0)
        SDL_Quit();
}

void bWindow::addRect(bRect location, uint8_t r = 255, uint8_t g = 255, uint8_t b = 255) {


    SDL_Rect SDL_location = {(int)location.x, (int)location.y, (int)location.width, (int)location.height};
    SDL_SetRenderDrawColor( sdlRenderer, r, g, b, 255);
    SDL_RenderDrawRect(sdlRenderer, &SDL_location);
    SDL_SetRenderDrawColor( sdlRenderer, 0, 0, 0, 255 );
}

// Initalizes and adds a texture to render scene
void bWindow::addTexture(const char* source, bRect src, bRect dest) {

    SDL_Surface* surface = IMG_Load(source);
    SDL_Texture* texture = SDL_CreateTextureFromSurface(sdlRenderer, surface);
    SDL_FreeSurface(surface);

    SDL_Rect SDL_src = {(int)src.x, (int)src.y, (int)src.width, (int)src.height};
    SDL_Rect SDL_dest = {(int)dest.x, (int)dest.y, (int)dest.width, (int)dest.height};

    SDL_RenderCopy(sdlRenderer, texture, &SDL_src, &SDL_dest);

}
