# EV5 compiling script

The included `scripts/` dir contains different os' scripts for being able to compile `.bin` builds that can be run in Kazi EV5. 

## Windows

1. Open with VS code.
2. The root dir where we place the `file.c` file (e.g. `main.c`) should have a `compiler` two levels above for this to work.
3. By opening **PowerShell** at the same place than `file.c` file and then typing `.\scripts\build.ps1` the whole process should complete, generating our expected `.bin` file which must be placed on **EV5 memory**.

## Notes

Please, consider following notes on your dev workflow.

### Intended use

These scripts were created to mimic our working commands:

1. `.o` file creation:

```
..\..\compiler\ARM\bin\arm-none-eabi-gcc -I..\..\compiler\includeRTOSEV5 -mcpu=cortex-m3 -mthumb -Os -fsigned-char -w -gdwarf-2 -DF_CPU=72000000UL -std=gnu99 -c main.c -o main.o
```

2. `.elf` file creation:

```
..\..\compiler\ARM\bin\arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -L..\..\compiler\includeRTOSEV5/o -T..\..\compiler\includeRTOSEV5\o\stm32_flash.ld --% -Wl,--gc-sections -Wl,-Map=main.map,-cref main.o -lm -o main.elf
```

3. `.elf` to `.bin` conversion

```
..\..\compiler\ARM\bin\arm-none-eabi-objcopy.exe -O binary main.elf main.bin
```

### Linux Support

We are currently working on a bash script that accomplishes what the **PowerShell** one does.

### Compiler Placement

Currently, we require `compiler/` dir to be two levels up from the file we want to compile, which is not the final goal, so these might change soon enough.