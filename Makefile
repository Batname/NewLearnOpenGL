CC := g++

UNAME := $(shell uname)

TARGET_EXEC ?= new_learn_open_gl
BUILDDIR := build
SRC_DIRS := src
BIN_DIR?=bin
BIN?=$(BIN_DIR)/$(TARGET_EXEC)

SOURCES := $(shell find $(SRC_DIRS) -type f -name *.cpp -or -name *.c -or -name *.s)
TEMP_OBJECTS_C = $(patsubst $(SRC_DIRS)/%.c,$(BUILDDIR)/%.c.o,$(SOURCES))
TEMP_OBJECTS_S = $(patsubst $(SRC_DIRS)/%.s,$(BUILDDIR)/%.s.o,$(TEMP_OBJECTS_C))
TEMP_OBJECTS_CPP = $(patsubst $(SRC_DIRS)/%.cpp,$(BUILDDIR)/%.cpp.o,$(TEMP_OBJECTS_S))
OBJECTS = $(TEMP_OBJECTS_CPP)

CFLAGS := -g -std=c++11 # -Wall

FRAMEWORK :=
ifeq ($(UNAME), Linux)
LIB := -lGLEW -lglfw -lGL -lX11 -lpthread -lXrandr -lXi -lSOIL -ldl
endif
ifeq ($(UNAME), Darwin)
LIB := -lGLEW -lglfw3 -lpthread
FRAMEWORK := -framework OpenGL
endif

INC := -I include

$(BIN): $(OBJECTS)
	@echo " Linking..."
	@mkdir -p $(BIN_DIR)
	@echo " $(CC) $^ -o $(BIN) $(LIB)"; $(CC) $^ -o $(BIN) $(FRAMEWORK) $(LIB)

#assembly
$(BUILDDIR)/%.s.o: $(SRC_DIRS)/%.s
	@mkdir -p $(BUILDDIR)
	$(AS) $(ASFLAGS) -c $< -o $@

# # c source
$(BUILDDIR)/%.c.o: $(SRC_DIRS)/%.c
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

# c++ source
$(BUILDDIR)/%.cpp.o: $(SRC_DIRS)/%.cpp
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