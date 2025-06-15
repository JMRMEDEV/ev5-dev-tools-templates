# EV5 DEV Tools Template

These tools make it easy to develop applications for the KAZI EV5 brick using ANSI C, without relying on the proprietary Scratch software.

Designed for more advanced developers who want full control over the EV5's capabilities.

Such tools include:

- VS Code **settings**
- Util automated scripts
- A sample `main.c` file that can get you started.

## Scripts

The included `scripts/` dir contains different os' scripts that allow us to:

- **Compile** `.c` programs (in `.bin` format) that can be run in **Kazi EV5**
- **Upload** `.bin` files to **Kazi EV5** through USB. 

### Prerequisites

#### Compiling

- Have downloaded official **Kazi-Scratch** from the sdk provided by your **Kazi-EV5** provider. **Linux Users**: you might need to somehow install the `.exe` file to get the **installation content**.
- Create a directory named `ev5-sdk` somewhere safe (e.g., `C:\ev5-sdk`).
- Locate the Kazi-Scratch installation directory (e.g., `C:\Program Files (x86)\Scratch2-KAZI`), then find the compiler subdirectory and copy the includeRTOSEV5 folder into your `ev5-sdk/` directory.
- Expose `ev5-sdk/` as an **environment variable**, so we can access such **path** anywhere in the system.
- Have **arm-none-eabi** installed and available as an **environment variable** (see [**Notes**](#notes) section for more info).
- Have **RTOSEV5** lib available two levels above `<filename>.c`.

#### Uploading

**USB**

- Plugged in the EV5 to PC through USB.
- Have turned the EV5 brick on and hit the **Download** button.

**WiFi**

- To be implented.

### Use

#### Compiling

1. Open project directory with VS code.
2. Open PowerShell in the same directory as your `<filename>.c`, which will be placed in the EV5’s internal memory via **upload**.
3. (**Optional**) If we have a name different from `main.c`, we have to pass the program name as a parameter. **E.g.**: For a file called `test.c`, we would have to execute as `.\scripts\build.ps1 --program=test`.

#### Uploading

1. Open project directory with VS code.
2. By opening **PowerShell** at the same place than `<filename>.c` file and then typing `.\scripts\upload.ps1` the whole process should complete. Copying our expected `.bin` file on **EV5 memory**.
3. (**Optional**) If we have a name different from `main.c`, we have to pass the program name as a parameter. **E.g.**: For a file called `test.c`, we would have to execute as `.\scripts\upload.ps1 --program=test`.

## Notes

Please, consider following notes on your dev workflow.

### Intended use

#### Compiling

These scripts were created to mimic our working commands that we tested with the compiler:

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

#### Scripts

We are currently working on a bash script that accomplishes what the **PowerShell** one does.

### Compiler

The project now supports using the officially distributed `arm-none-eabi` compiler, instead of relying on the version bundled with **Kazi-Scratch**.

As reference, this was the original compiler version: 

1. `arm-none-eabi-gcc`

```
arm-none-eabi-gcc.exe (GNU Tools for ARM Embedded Processors) 4.8.4 20140526 (release) [ARM/embedded-4_8-branch revision 211358]
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

2. `\arm-none-eabi-objcopy`

```
GNU objcopy (GNU Tools for ARM Embedded Processors) 2.23.2.20140529
Copyright 2012 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) any later version.
This program has absolutely no warranty.
```
- We installed practically the same version from https://launchpad.net/gcc-arm-embedded/+download?direction=backwards&memo=10

### Next Steps

- Enable support for uploading programs via **WiFi**
- Add full **Linux** compatibility
- Test and document compatibility with **newer versions of `arm-none-eabi`**