# Cut 68060-261031-54

The k46 module kernel, kabi k46.1.4 (abi 18c0a1c9), cut from this repository's `k46-module` at `eae06ae`: the
recipe of [`68060-261031-53`](../68060-261031-53/README.md) with the module core, the kit and the family tools
from amix `74405ce`. That revision carries core patch 0048: a demand-class filesystem module loads at the first
mount of its type, through a stub `vfssw` row the core puts in a spare row (amix-dlm contract C4-6 section 5).
Its kabi is minor 4, which adds no name to the DDI, so `abi-k46.1.4.txt` equals 1.3's and the abi is unchanged.

| File | What |
|---|---|
| `SHA256SUMS-68060-261031-54` | the seven files of record, paths relative to the cut's run root |
| `cut.sh` | the recipe: `cut.sh OUT` with the inputs below; its sums must equal the file above |
| `build-c.sh`, `post-c.sh` | -53's, the module core from the amix clone's `kernel/dlm` at `74405ce`, the abi text `abi-k46.1.4.txt` |
| `families-c.json` | -53's family contract, unchanged |
| `stamp_buildid.py`, `blocks.py` | the build-id stamper shim (one stamp, at the fpe pass) and the block pin |
| `ufsmod/` | the ufs module's build directory (carve.py's wrapper, `$build` this cut's) |

Inputs (`cut.sh` names each by an environment variable; all of them public): as -53's, with this repository at
`eae06ae` (where `relink-040-dlm.sh` and `relink-040-kinfo.sh` default to kabi k46.1.4 and the core at `74405ce`)
and amix at `74405ce`. gcc14's binutils (2.43.1) as `m68k-linux-gnu-*`, through amix's `toolchain/m68k-gnu-bin`
when `G14` is given.

The build is stamped `68060-261031-54`: `SOURCE_DATE_EPOCH=1793404800` (2026-10-31), the build sequence seeded
`261031 53`, and the block lookup pinned to 50-99.

Against -53 (`affe663a`): `.text` +916 bytes, `.data` +388, `.bss` +128, the core's demand-filesystem code and
its stub table (`dlm_fsstub`, `fsstub_mount`, `dlm_fsdem`); `kinfo_kabi` and the sidecar's `kabi=` read
`k46.1.4`. The abi, both ufs objects and the base (`b-new`) are -53's; the ufs module differs in its build id only
(one byte).

`cut.sh` reproduces all seven sums on the host with the control (k0-gates ALL GREEN, `ksymgate` 12 of 12 on the
shipped form, `mkabi --check` no moved line) and in `amix-toolchain:dist` without it (k0-gates' one refusal is
the missing control). Not yet booted.
