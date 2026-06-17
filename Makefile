# =============================================================================
# Makefile for hello.asm
# Makes it easy (and educational) for students to build the assembly program.
#
# Usage:
#   make          - build the hello binary
#   make run      - build and execute
#   make clean    - remove object file and binary
# =============================================================================

ASM      := nasm
ASMFLAGS := -f elf64
LD       := ld
TARGET   := hello
SRC      := hello.asm
OBJ      := $(SRC:.asm=.o)

.PHONY: all clean run

all: $(TARGET)

# Link the object file into a final executable.
# We use the raw linker (ld) on purpose — no gcc, no C runtime, no hidden code.
$(TARGET): $(OBJ)
	$(LD) $(OBJ) -o $(TARGET)
	@echo ""
	@echo "Build successful!"
	@echo "Run the program with: ./$(TARGET)"
	@echo ""

# Assemble the .asm source into an ELF object file.
$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) $< -o $@

# Remove generated build products.
clean:
	rm -f $(OBJ) $(TARGET)

# Convenience target: build + run in one command.
run: $(TARGET)
	./$(TARGET)
