# EV5 DEV Tools Template

All the included tools allow us to quickly and easily develop applicacions in **ANSI C** without the need of **Scratch** software, meant for more adavanced developers who want to get all from **KAZI EV5** brick.

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
- Create a `ev5-sdk/` directory somewhere safe (**e.g.** `C:\ev5-sdk`).
- Locate your directory **Kazi-Scratch** installation directory (**e.g.** `C:\Program Files (x86)\Scratch2-KAZI`) and in there we have to identify `compilers` subdirectory and grab `includeRTOSEV5` which we will copy to our `ev5-sdk/` directory.
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
2. By opening **PowerShell** at the same place than `<filename>.c` file and then typing `.\scripts\build.ps1` the whole process should complete, generating our expected `.bin` file which must be placed on **EV5 memory**.
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

We know are able to use the **arm-non-eabi** compiler that came from an original source, rather than using the version originally packed with **KAZI-Scratch**.

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

- Be able to **upload** programs to EV5 through **WiFi**.
- Add full Linux support.
- To test which newer **arm-none-eabi** versions could be compatible with **EV5**.