Q ?= @
CC := g++

DESTDIR?=bin
TARGET?=new_learn_opengl
DISTFILE?=$(DESTDIR)/$(TARGET)
BIN_DIR?=bin
BIN?=$(BIN_DIR)/$(TARGET)

SRCDIR := src
BUILDDIR := build

SRCEXT := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

CFLAGS := -g -std=c++0x # -Wall

LIB := -lGLEW -lglfw -lGL -lX11 -lpthread -lXrandr -lXi -lSOIL
INC := -I include

$(BIN): $(OBJECTS)
	@echo " Linking..."
	@mkdir -p $(BIN_DIR)
	@echo " $(CC) $^ -o $(BIN) $(LIB)"; $(CC) $^ -o $(BIN) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

.PHONY: clean
clean:
	@echo " Cleaning...";
	@echo " $(RM) -r $(BUILDDIR) $(BIN_DIR)"; $(RM) -r $(BUILDDIR) $(BIN_DIR) 2> /dev/null

.PHONY: uninstall
uninstall:
	@echo "Uninstall ..."
	@echo "$(OBJECTS)"
	@echo " $(RM) $(DISTFILE)"; $(RM) $(DISTFILE) 2> /dev/null

.PHONY: install
install:
	@echo "Install ..."
	@echo " $Q mv $(BIN) $(DESTDIR)"
	$Q mv $(BIN) $(DESTDIR)