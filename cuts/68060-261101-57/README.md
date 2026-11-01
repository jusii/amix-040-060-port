# Cut 68060-261101-57

The k46 module kernel, kabi k46.1.4 (abi 18c0a1c9), cut from this repository's `k46-module` at `5a0d8cd` and amix
`ac168e5`: the recipe of [`68060-261101-56`](../68060-261101-56/README.md) with these changes of input.

- This repository at `5a0d8cd`, which is -56's `2e3b9d5` plus one commit: the idle override in
  `src/runtime040.s` defines its own `waitloc` (ISSUE-113). `clock()` and `clock_int()` take a tick as idle only
  when the interrupted PC equals `waitloc`; with the stock label behind the weakened stock idle, every idle tick
  was booked as system time to the last process that ran (fsflush) and sysinfo's idle stayed 0.
- amix `ac168e5`, whose `kernel/dlm` sources, `kernel/k30/tools` and contracts and `toolchain/m68k-gnu-bin` are
  -56's `3b53a8a`'s (only documents, changelogs and package records changed between them);
  `kernel/dlm/toolchain.pin` is gcc-cross-amix `33ebadc`, compiled into the core (DLM_PIN) and written as the
  sidecar's `pin=`.

| File | What |
|---|---|
| `SHA256SUMS-68060-261101-57` | the seven files of record, paths relative to the cut's run root |
| `cut.sh` | the recipe: `cut.sh OUT` with the inputs below; its sums must equal the file above |
| `build-c.sh`, `post-c.sh` | -56's, at amix `ac168e5` |
| `families-c.json` | -56's family contract, unchanged |
| `stamp_buildid.py`, `blocks.py` | the build-id stamper shim (one stamp, at the fpe pass) and the block pin |
| `ufsmod/` | the ufs module's build directory (carve.py's wrapper, `$build` this cut's) |

Inputs (`cut.sh` names each by an environment variable; all of them public): as -56's, with this repository at
`5a0d8cd` and amix at `ac168e5`.

The build is stamped `68060-261101-57`: `SOURCE_DATE_EPOCH=1793491200` (2026-11-01), the build sequence seeded
`261101 56`, and the block lookup pinned to 50-99.

Against -56 (`8ef91062`): `.text`, `.data` and `.bss` are the same size (unix 2424876 bytes); the change is the
symbol `waitloc` (`.text 0xdaccc`, the strong `idle` + 4, where -56 resolved the stock `0x1a0`) and the build id.
The base moves with it (`b-new` `87ee0dd4`, -56's `9aa74906`: the override is linked there). The sidecar's ident,
arena and ksym addresses, the abi and both ufs objects do not move; the ufs module differs from -56's in its build
id only. The kit is -56's, so the module packages built for
-56 (pin `33ebadc`, kabi k46.1.4) load unchanged.

`cut.sh` reproduces all seven sums twice in `amix-toolchain:gca-33ebadc` (gcc-cross-amix `33ebadc`, gcc14's
binutils 2.43.1 from the image's `/opt/amix/gcc14-cross-amix/build` as `G14`): once with the control (k0-gates
ALL GREEN) and once without it (k0-gates' one refusal is the missing control); `ksymgate` 12 of 12 on the shipped
form, `mkabi --check` no moved line, the sidecar's `pin=` equal to `kernel/dlm/toolchain.pin`.
