# FMS Link

A small PCB that plugs into a Game Boy link cable and breaks the sync lines out to a
3.5mm TRS jack, for clocking [FMS](https://lo-bit.club/fms/) and
[nanoloop](https://nanoloop.com/) against other gear — Pocket Operators, Volcas,
eurorack, anything that takes an analog clock.

![Board, front](images/board-front.png)
![Board, back](images/board-back.png)

The previews are rendered bare, without the jack's 3D model, so the copper and
silkscreen stay visible.

## Wiring

| TRS    | Game Boy link | Purpose      |
| ------ | ------------- | ------------ |
| Tip    | SC (pin 5)    | Serial clock |
| Ring   | SD (pin 4)    | —            |
| Sleeve | GND (pin 6)   | Ground       |

This matches the analog clock cable wiring in the
[FMS guide](https://lo-bit.club/fms/guide).

`VDD`, `SO` and `SI` are not connected. The jack's shunt terminal (pin 4) is the tip's
normalling contact — internally shorted to the tip when nothing is plugged in, and
released when a plug is inserted. It is left unconnected.

## Bill of materials

| Ref | Part               | Notes                                       |
| --- | ------------------ | ------------------------------------------- |
| J1  | **WQP-WQP729JH-B** | 3.5mm right-angle switched **stereo** jack  |


> **Order the blue `-B` part, not the red `-R`.** Per the
> [manufacturer datasheet](https://www.thonk.co.uk/wp-content/uploads/2022/10/WQP-WQP729JH.pdf),
> the `-R` is mono and has no ring contact, so it cannot carry `SD`.
> Thonk sells both on their [729JH page](https://www.thonk.co.uk/shop/729jh-jacks/).

The board is 15.0 × 27.9 mm including the link-port tongue, two layers, no other parts.
The jack's threaded barrel protrudes 4.3 mm past the top edge.

### Ordering from OSH Park

`make zip` writes `fms-link-gerbers.zip` — flat, no enclosing folder, with the `.gbrjob`
manifest left out. Upload it at [oshpark.com](https://oshpark.com/).

The board is 0.649 sq in, so OSH Park's 2-layer service runs about **$3.25 for three
copies** plus shipping. Check their rendered preview before checkout — in particular that
the four jack slots come through as slots rather than round holes.

## Credits

The Game Boy link-port edge-connector footprint (`gb-link-socket`) and the board tongue
geometry come from Nick Palmer's
[gb-link-cable](https://github.com/Palmr/gb-link-cable) breakout board — the pad
positions and tongue outline are Nick Palmer's, reformatted here for KiCad 10. Nick Palmer's
design is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). That
project in turn followed
[this devlog](http://obskyr.io/lanette/devlog/making-a-game-boy-link-cable-breakout-board/)
on building a link cable breakout, and Nick Palmer wrote up the build
[on palmr.co.uk](https://palmr.co.uk/posts/26-gameboy-link-cable-breakout/).

Everything else here — the TRS jack footprint and 3D model, the schematic, the board
outline and routing — is new.

## License

FMS Link is © 2026 Levi Kennedy and licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/); see [LICENSE](LICENSE). You
may copy, modify, build and sell it, provided you credit FMS Link and link back to this
repository. The `gb-link-socket` footprint and tongue geometry remain Nick Palmer's work
under the same license, and reuse of them should credit Nick Palmer as described above.
