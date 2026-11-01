# Cut 68060-261101-56

The k46 module kernel, kabi k46.1.4 (abi 18c0a1c9), cut from this repository's `k46-module` at `2e3b9d5` and amix
`3b53a8a`: the recipe of [`68060-261031-55`](../68060-261031-55/README.md) with these changes of input.

- This repository at `2e3b9d5`:
  - ITT0/DTT0 supervisor-only (`4c6ea89`, ISSUE-112): a user process no longer reaches physical memory below 1 GiB;
  - no legacy 030 segment tables in user address spaces (`c4058ad`, ISSUE-110): hat_map's `hat_growsdt` is
    retargeted to `hat_growsdt_user`, the legacy teardown retired;
  - the swapadd guard (`35bfdf8`, ISSUE-111): `swap -a` fails with ENOMEM instead of sleeping on its anon array;
  - unlimited soft data and vmem limits (`eb22919`, relink-040-fpe.sh step 8.9: `rlimits[]` SDATLIM and SVMMLIM
    `0x01000000` -> `0x7fffffff`; SSTKLIM stays 16 MiB).
  - `d0d7c02` (hat_pagesync's conditional flush) is reverted by `2e3b9d5`: the cut does not carry it.
- amix `3b53a8a`: the module core with patches 0050 (the short-memory message) and 0051 (device majors from the
  boot-set manifest's major records, so a generation needs kbootset -34 or later), the kit and the family tools;
  `kernel/dlm/toolchain.pin` is gcc-cross-amix `33ebadc`, compiled into the core (DLM_PIN) and written as the
  sidecar's `pin=`.

| File | What |
|---|---|
| `SHA256SUMS-68060-261101-56` | the seven files of record, paths relative to the cut's run root |
| `cut.sh` | the recipe: `cut.sh OUT` with the inputs below; its sums must equal the file above |
| `build-c.sh`, `post-c.sh` | -55's, the module core from the amix clone's `kernel/dlm` at `3b53a8a`; post-c.sh takes the sidecar's `pin=` from `kernel/dlm/toolchain.pin` and checks that the sidecar's `pin=` equals it and that the image carries it |
| `families-c.json` | -55's family contract, unchanged |
| `stamp_buildid.py`, `blocks.py` | the build-id stamper shim (one stamp, at the fpe pass) and the block pin |
| `ufsmod/` | the ufs module's build directory (carve.py's wrapper, `$build` this cut's) |

Inputs (`cut.sh` names each by an environment variable; all of them public): as -55's, with this repository at
`2e3b9d5`, amix at `3b53a8a`, and gcc-cross-amix at `33ebadc` (its `build/` inside a git checkout that has
`33ebadc`: relink-040-dlm.sh checks the installed wrapper against the core's pin, so a toolchain built before
`33ebadc` is refused). gcc14's binutils (2.43.1) as `m68k-linux-gnu-*`, through amix's `toolchain/m68k-gnu-bin`
when `G14` is given.

The build is stamped `68060-261101-56`: `SOURCE_DATE_EPOCH=1793491200` (2026-11-01), the build sequence seeded
`261101 55`, and the block lookup pinned to 50-99.

Against -55 (`a31055d9`): `.text` +776 bytes, `.data` +172, `.bss` +16 (unix 2424876 bytes). The sidecar's
`pin=` is `gcc-2.7.2.3-33ebadc` and its ident, arena and ksym addresses move with `.text`. The abi, both ufs objects
and the shape of the module are -55's; the ufs module differs in its `.moddata` pin (`33ebadc`) and build id. The
base (`b-new` `9aa74906`) is the base of the test build -94.

`cut.sh` reproduces all seven sums twice in `amix-toolchain:gca-33ebadc` (gcc-cross-amix `33ebadc`, gcc14's
binutils 2.43.1 from the image's `/opt/amix/gcc14-cross-amix/build` as `G14`): once with the control (k0-gates
ALL GREEN) and once without it (k0-gates' one refusal is the missing control); `ksymgate` 12 of 12 on the shipped
form, `mkabi --check` no moved line, the sidecar's `pin=` equal to `kernel/dlm/toolchain.pin`.
