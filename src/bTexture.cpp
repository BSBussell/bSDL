// Bee Bussell
// Sep 8, 2021
// For Later

#include "bTexture.h"

bTextureManager::bTextureManager(SDL_Renderer renderer) {

	_sdl_renderer = renderer;
}

bTextureManager::~bTextureManager() {

	clearCache();
}

// Load the texture either by creating a new one or grabbing it from the cache
bTexture *bTextureManager::loadTexture(const char *path, bRect dim) {

	std::string absPath = BML_GetPath(path);

	// No matter what we're make a new bTexture
	bTexture newTexture = new bTexture();
	newTexture.src = dim;
	newTexture.path = absPath;

	// If we've already loaded this image
	auto iter = _loaded_textures.find(absPath);
	if (iter != _loaded_textures.end()) {

		// Setup 
		newTexture.texture = iter -> second;

		// Increase the ref count
		auto refs_iter = _refs.find(iter -> second);
		refs_iter -> second++;

		return newTexture;
	}

	// Create new texture
	SDL_Surface* surface = IMG_Load(absPath.c_str());
    newTexture.texture = SDL_CreateTextureFromSurface(_sdl_renderer, surface);
    SDL_FreeSurface(surface);

    // Setup our look ups and reference counter
    _loaded_textures[absPath] = newTexture.texture;
    _refs[newTexture.texture] = 1;
}

// Kinda do the opposite of the above
void unloadTexture(bTexture *texture) {

	// Decrease the ref count
	auto refs_iter = _refs.find(texture->texture);
	refs_iter->second--;

	// If the ref count is zero, delete it from the cache and free memory
	if (refs_iter->second == 0) {
		auto loaded_iter = _loaded_textures.find(texture->path);
		if (loaded_iter != _loaded_textures.end()) {
			SDL_DestroyTexture(loaded_iter->second);
			_loaded_textures.erase(loaded_iter);
		}
		_refs.erase(refs_iter);
	}

	// Free the bTexture memory
	delete texture;
}

// Clear the maps and free all memory, extremely dangerous to use,,, please be careful
void clearCache() {

	// Delete all loaded textures and reset the reference counters
	for (auto& texture : _loaded_textures) {
		SDL_DestroyTexture(texture.second);
	}
	_loaded_textures.clear();
	_refs.clear();

}
