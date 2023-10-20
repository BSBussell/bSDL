# BML

BML is the SDL wrapper that [BlueKit2D](https://github.com/BSBussell/BlueKit2D) will use. It is designed to handle many of the lower level task for the engine and keep them obstructed so that I can focus more on the structure of components and data when creating the engine.

### Uses
This project is mostly for personal use so I do not plan on writing much in-depth documentation on how it works other than my personal comments I leave for myself. Just like ask me if you want to know how something works but really I am trying to keep it as straight forward as possible

### Build Instructions
Install SDL2, SDL_Image, SDL_Mixer, and SDL_TTF following instructions based off your OSs for this.
Once you have done that you can copy this code into your terminal emulator of choice

```
git clone https://github.com/BSBussell/BML.git
cd BML
mkdir build
cd build
cmake ..
make
sudo make install
```

This will create the linker objects to use when compiling with your program.
Alternatively you can use the CMakeLists.txt to generate make files using CMake and then make from there.

#### Tests
The above will also compile tests that you can run.

Currently there is only one test JSONtest. 

### Not working
Please be patient as the ~~makefile~~CMakeLists.txt is subject to change as this project grows in size and I am one person both developing my this engine, attempting to graduate from college, and looking for a job.
