CC=gcc
CPP=g++

CFLAGS=-fexceptions -fstack-protector-all -fsanitize=address -g -O0 -Wall -Wextra $(shell pkg-config --cflags gtk+-3.0 opus codec2 portaudio-2.0) -Isrc/ -DMINIUPNP_STATICLIB -DDEBUG
LDFLAGS=$(shell pkg-config --libs gtk+-3.0 opus codec2 portaudio-2.0)

ODIR=obj

SOURCES_CPP=$(wildcard src/*.cpp) $(wildcard src/Gtk/*.cpp)
SOURCES_C=$(wildcard src/miniupnpc/*.c)

_OBJ_CPP = $(patsubst %.cpp,%.o,$(SOURCES_CPP))
_OBJ_C = $(patsubst %.c,%.o,$(SOURCES_C))
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ_CPP)) $(patsubst %,$(ODIR)/%,$(_OBJ_C))


$(ODIR)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) -c -o $(ODIR)/$(notdir $@) $< $(CFLAGS)
	
$(ODIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CPP) -c -o $(ODIR)/$(notdir $@) $< $(CFLAGS)

all: $(OBJ)
	@mkdir -p bin
	$(CPP) -o bin/tincanphone $(patsubst %,$(ODIR)/%,$(notdir $^)) $(CFLAGS) $(LDFLAGS)

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ tincanphone