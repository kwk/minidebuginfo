# Creating an LLVM YAML file from a real program

Inside the `source` directory you can find a small C++ program containing a `myexe` target that links against the `mylib` target. No third party libraries are needed. 

Run `make` in the root directory!

The goal is to generate a `final.yaml` file that contains an ELF object in YAML representation. The resulting ELF file should contain a `.dynsym` and a `.gnu_debugdata` section which itself contains a `.symtab` section.

## Current Status

Right now the last step of verifying the ELF object that was generated from `yaml2obj final.yaml` doesn't work:

```
yaml2obj final.yaml | llvm-readelf -WSs && echo "ALL DONE SEE final.yaml" || echo "AN ERROR OCCURED ^"
There are 27 section headers, starting at offset 0x40:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .interp           PROGBITS        00000000004002a8 000700 00001c 00   A  0   0  1
  [ 2] .note.ABI-tag     NOTE            00000000004002c4 00071c 000020 00   A  0   0  4
  [ 3] .note.gnu.build-id NOTE           00000000004002e4 00073c 000024 00   A  0   0  4
  [ 4] .gnu.hash         GNU_HASH        0000000000400308 000760 000050 00   A 25   0  8
  [ 5] .gnu.version      VERSYM          0000000000400564 0007b0 00001c 00   A 25   0  2
  [ 6] .gnu.version_r    VERNEED         0000000000400580 0007d0 000020 00   A 26   0  8
  [ 7] .init             PROGBITS        0000000000401000 0007f0 00001b 00  AX  0   0  4
  [ 8] .text             PROGBITS        0000000000401020 000810 0001c5 00  AX  0   0 16
  [ 9] .fini             PROGBITS        00000000004011e8 0009d8 00000d 00  AX  0   0  4
  [10] .rodata           PROGBITS        0000000000402000 0009e8 000010 00   A  0   0  8
  [11] .eh_frame_hdr     PROGBITS        0000000000402010 0009f8 00003c 00   A  0   0  4
  [12] .eh_frame         PROGBITS        0000000000402050 000a38 0000e0 00   A  0   0  8
  [13] .init_array       INIT_ARRAY      0000000000403e20 000b18 000008 00  WA  0   0  8
  [14] .fini_array       FINI_ARRAY      0000000000403e28 000b20 000008 00  WA  0   0  8
  [15] .dynamic          DYNAMIC         0000000000403e30 000b28 0001c0 10  WA 26   0  8
  [16] .got              PROGBITS        0000000000403ff0 000ce8 000010 00  WA  0   0  8
  [17] .got.plt          PROGBITS        0000000000404000 000cf8 000018 00  WA  0   0  8
  [18] .data             PROGBITS        0000000000404018 000d10 000004 00  WA  0   0  1
  [19] .bss              NOBITS          000000000040401c 000d14 000004 00  WA  0   0  1
  [20] .comment          PROGBITS        0000000000000000 000d14 000056 00  MS  0   0  1
  [21] .gnu_debugdata    PROGBITS        0000000000000000 000d6a 0008b0 00      0   0  1
  [22] .symtab           SYMTAB          0000000000000000 001620 000018 18     23   1  8
  [23] .strtab           STRTAB          0000000000000000 001638 000001 00      0   0  1
  [24] .shstrtab         STRTAB          0000000000000000 001639 0000fe 00      0   0  1
  [25] .dynsym           DYNSYM          0000000000000000 001738 000150 18   A 26   1  8
  [26] .dynstr           STRTAB          0000000000000000 001888 00007f 00   A  0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

Symbol table '.dynsym' contains 14 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name

Error reading file: invalid sh_entsize
```

