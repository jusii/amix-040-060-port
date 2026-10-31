# Cut 68060-261031-55

The k46 module kernel, kabi k46.1.4 (abi 18c0a1c9), cut from this repository's `k46-module` at `eae06ae`: the
recipe of [`68060-261031-54`](../68060-261031-54/README.md) with the module core, the kit and the family tools
from amix `3c3e353`. That revision adds core patch 0049: a first-use load (a demand major's first open, a
demand filesystem's first mount) never waits for memory, and the load's copy of the module file is sized exactly
and freed before the module's `_load` runs (amix-dlm contract C3-6). The kabi stays k46.1.4 and the abi is
unchanged.

| File | What |
|---|---|
| `SHA256SUMS-68060-261031-55` | the seven files of record, paths relative to the cut's run root |
| `cut.sh` | the recipe: `cut.sh OUT` with the inputs below; its sums must equal the file above |
| `build-c.sh`, `post-c.sh` | -54's, the module core from the amix clone's `kernel/dlm` at `3c3e353` |
| `families-c.json` | -54's family contract, unchanged |
| `stamp_buildid.py`, `blocks.py` | the build-id stamper shim (one stamp, at the fpe pass) and the block pin |
| `ufsmod/` | the ufs module's build directory (carve.py's wrapper, `$build` this cut's) |

Inputs (`cut.sh` names each by an environment variable; all of them public): as -54's, with amix at `3c3e353`.

The build is stamped `68060-261031-55`: `SOURCE_DATE_EPOCH=1793404800` (2026-10-31), the build sequence seeded
`261031 54`, and the block lookup pinned to 50-99.

Against -54 (`8eae8e2c`): `.text` +520 bytes, `.data` +100, `.bss` +32, the core's no-wait first-use path.
The abi, both ufs objects and the base (`b-new`) are -54's; the ufs module differs in its build id only (one
byte).

`cut.sh` reproduces all seven sums on the host with the control (k0-gates ALL GREEN, `ksymgate` 12 of 12 on the
shipped form, `mkabi --check` no moved line) and in `amix-toolchain:dist` without it (k0-gates' one refusal is
the missing control). Not yet booted.
