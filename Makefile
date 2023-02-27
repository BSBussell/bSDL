#Directories
OBJDIR = obj
TESTOBJDIR = tests/obj

#CC specifies which compiler we're using
CC = g++

BMLsrc = $(wildcard src/*.cpp)

BMLobj := $(notdir $(BMLsrc))
BMLobj := $(addprefix $(OBJDIR)/, $(BMLobj))
BMLobj := $(BMLobj:.cpp=.o)
		 
testsrc = $(wildcard tests/src/*.cpp)

testobj := $(notdir $(testsrc))
testobj := $(addprefix $(TESTOBJDIR)/, $(testobj))
testobj := $(testobj:.cpp=.o)

#CFLAGS specifies the additional compilation options we're using
CFLAGS := -Wall -Wextra -std=c++17 -O3

#IFLAGS specifies which directory to check for include
IFLAGS := -Iinc

#LFLAGS specify the libraries we're linking against
LFLAGS  := -lSDL2 -lSDL2_image -lSDL2_mixer -lBML

#WFLAGS specifies that we know what we are doing with ar
WFLAGS := -no_warning_for_no_symbols

#Give us some bold text plz
bold := $(shell tput bold)
sgr0 := $(shell tput sgr0)

#Library Path
ifeq ($(LPATH),)
    LPATH := /usr/lib
endif

#Get Os name
OS := $(shell uname)
ifeq ($(OS), Darwin)
	LPATH = /usr/local/lib
	HEADERPATH = /usr/local/include/BML/
else
	LPATH = /usr/lib
	HEADERPATH = /usr/include/BML/
endif	

#all rule for just compiling everything
.PHONY: all
all: BML build Tests
	

.PHONY: BML
BML: $(BMLobj)

#Tests for only compiling tests
.PHONY: Tests
Tests: BML build install JSONTest AnimationTest SheetTest SoundTest TextureTest EventTest WindowTest

.PHONY: build
build: $(BMLobj)
	@printf "\n$(bold)----------Building BML LIB File----------------$(sgr0)\n"
	ar rc bin/libBML.a $(BMLobj)
	ranlib bin/libBML.a 

.PHONY: install
install: build
	@printf "\n$(bold)----------INSTALLING LIBRARY TO DIRECTORY-------$(sgr0)\n"
	sudo install -m 644 bin/libBML.a $(LPATH)
	@printf "\n$(bold)--------------PLACING HEADER FILES--------------$(sgr0)\n"
	sudo cp -rf inc/* $(HEADERPATH)

ValgrindTest: Tests
	valgrind --track-origins=yes --suppressions=window.supp --leak-check=full --show-leak-kinds=all ./tests/bin/AnimationTest

JSONTest: tests/obj/jsonTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

AnimationTest: tests/obj/animationTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

SheetTest: tests/obj/sheetTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

SoundTest: tests/obj/soundTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

TextureTest: tests/obj/textureTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

EventTest: tests/obj/eventTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

WindowTest: tests/obj/windowTest.o build
	@printf "\n$(bold)----------COMPILING TEST FILE: $@----------$(sgr0)\n"
	$(CC) $< $(CFLAGS) $(LFLAGS) -o tests/bin/$@

# Rules for BML obj files
$(OBJDIR)/%.o: src/%.cpp
	@printf "\n$(bold)----------COMPILING BML OBJ FILE: $(notdir $@)----------$(sgr0)\n"
	$(CC) $^ $(CFLAGS) $(IFLAGS) -c -o $@ 

# Rules for test obj files
$(TESTOBJDIR)/%.o: tests/src/%.cpp
	@printf "\n$(bold)----------COMPILING TEST OBJ FILE: $(notdir $@)----------$(sgr0)\n"
	$(CC) $^ $(CFLAGS) $(IFLAGS) -c -o $@ 

.PHONY: clean
clean: 
	@printf "\n$(bold)----------REMOVING PREVIOUS BUILDS----------$(sgr0)\n"
	rm -f $(BMLobj) 
	rm -f $(testobj)
	rm -f bin/*
	rm -f a.out tests/bin/*
