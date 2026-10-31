# Cut 68060-261031-53

The k46 module kernel, kabi k46.1.3 (abi 18c0a1c9), cut from this repository's `k46-module` at `2e7f715`: the
recipe of [`68060-261031-52`](../68060-261031-52/README.md) with two changes of input and none of design:

- the module core, the kit and the family tools from amix `b391504`, whose major registry carries `c 48 random`
  (amix `a8719fb`): the kernel compiles the registry in, so the random module's major is the kernel's own;
- one binutils: gcc14-cross-amix's (2.43.1), as `m68k-linux-gnu-*` through amix's `toolchain/m68k-gnu-bin`, the
  set make dist's container has.

The 68030 line's matching cut is amix `kernel/k30/cuts/68030-261031-64` (also amix `b391504`).

| File | What |
|---|---|
| `SHA256SUMS-68060-261031-53` | the seven files of record, paths relative to the cut's run root |
| `cut.sh` | the recipe: `cut.sh OUT` with the inputs below; its sums must equal the file above |
| `build-c.sh`, `post-c.sh` | -52's, the module core taken from the amix clone's `kernel/dlm` at `b391504` |
| `families-c.json` | -52's family contract, `isp060_pkg.o` pinned at the bytes 2.43.1 assembles (below) |
| `stamp_buildid.py`, `blocks.py` | the build-id stamper shim (one stamp, at the fpe pass) and the block pin |
| `ufsmod/` | the ufs module's build directory (carve.py's wrapper, `$build` this cut's) |

Inputs (`cut.sh` names each by an environment variable; all of them public):

- this repository at `2e7f715` (`git archive`, the build tree; and a clone, which the kit and the gates read);
  from its history, the five patchers `families-c.json` pins, as -52;
- amix at `b391504`, cloned: `kernel/dlm` (the module core, `make kit`), `kernel/k30/tools` and `contracts`
  (the sddevsize and support-probe injectors, `emit-family-chains.py`, `k0-gates.py`), `toolchain/m68k-gnu-bin`;
- amix-paula at `62fdcab`; gcc-cross-amix at amix's `toolchain/gcc-cross-amix.pin` (gcc 2.7.2.3, `8949028`), its
  `build/` inside a git checkout holding that commit; gcc14-cross-amix's `build/` (`G14`), or its `m68k-elf-*`
  already first on PATH as `m68k-linux-gnu-*` (`cut.sh` refuses any assembler or linker but 2.43.1);
  amigaux/amix-system's `kernels/2.1c/unix`; NetBSD 10.1's `syssrc.tgz`;
- optional: the frozen candidate-3 kernel (`5aa7d732`) that emit and k0-gates compare against.

The build is stamped `68060-261031-53`: `SOURCE_DATE_EPOCH=1793404800` (2026-10-31), the build sequence seeded
`261031 52`, and the block lookup pinned to 50-99.

Against -52 (`c902f310`): `.text` -8 bytes, `.data` +20 (the registry's `random` entry), `.rela.text` 39
relocations fewer; kabi k46.1.3 and its abi are unchanged, and so are both ufs objects. The `.text` bytes are
two objects assembled from NetBSD's sources:

- `fpsp040.o` -4: `stan.s:231`'s `lea PITBL+0x200,%a1` is PC-relative under 2.43.1, absolute under 2.46
  (`build-fpsp040.sh` takes both sizes since `9c36454`);
- `isp060_pkg.o` -4: the glue's `jmp` to `isp060_image` is PC-relative, and the call-out table's addends move
  with it. The package image (0x80-0x1880, the scan060 known-data word at 0x5e4 in it) is byte-equal, so
  `families-c.json` pins the new object (`5daed669`, was `50f04500`) on the same judgement.

Branches to global labels that 2.46 left to `R_68K_PC16` relocations, 2.43.1 resolves itself: the 39.

Three fixes let the recipe run in make dist's container (python 3.12, git 2.43, mawk, a read-only toolchain),
none of which changes a byte: `d9213b1` (the staged audio sources made writable), `4c22195` (relink-040-dlm.sh
finds gcc-cross-amix's checkout through a linked `build/`), `2e7f715` (no gawk `strtonum`).

`cut.sh` at `2e7f715` reproduces all seven sums on the host with the control (k0-gates ALL GREEN, `ksymgate`
12 of 12 on the shipped form, `mkabi --check` no moved line) and in `amix-toolchain:dist` without it (k0-gates'
one refusal is the missing control); at `9c36454`, before the three fixes, two host runs gave the same sums.
Booted in emulation (an A4000 with a 68060): kbootset check, build and commit, then the kernel up as
`68060-261031-53` (uname), mark-good, the rig's 35 checks PASS; ufs, z3660scsi and z3660eth load, a cp/cmp of the
kernel is clean, and the freeq guard is live (`fqg_magic` 46514721, 363 calls, `fqg_run` 0).
Hardware acceptance on the A4000T follows.
