// QingPu WQP-WQP729JH-B — 3.5mm right-angle switched stereo (TRS) jack
// Approximate mechanical model for KiCad 3D viewer clearance checks.
// Datasheet: https://www.thonk.co.uk/wp-content/uploads/2022/10/WQP-WQP729JH.pdf
//
// Coordinate system matches the KiCad footprint local frame:
//   origin  = bushing / panel face (front face of the plastic body)
//   +X      = barrel axis, pointing back into the body (pins are at +X)
//   -X      = threaded barrel protrudes this way, out past the panel face
//   XY      = board plane, Z = up off the board surface (body sits on z = 0)
//
// NOTE: the exported mesh negates Y so that it lands correctly in KiCad's
// 3D frame, whose +Y is opposite the footprint's +Y. See kicad_frame() below.
//
// Dimensional honesty over cosmetic detail: threads are a plain cylinder,
// fillets and the internal switch leaf are omitted.

$fn = 64;

// ---- Body ------------------------------------------------------------------
body_len    = 20.2;   // X, panel face to rear face
body_wid    = 11.0;   // Y, full width (+/- 5.5)
body_tall   = 10.5;   // Z, total height above board surface

// Front view shows a 10 x 7.8 housing square with the bore centred in it.
house_wid   = 10.0;   // Y of the raised housing block
house_tall  = 7.8;    // Z of the raised housing block

// Bore axis height: centred in the 7.8 housing square.
bore_z      = house_tall / 2;

// ---- Threaded barrel -------------------------------------------------------
barrel_dia  = 6.0;    // M6 x 0.5 major diameter
barrel_out  = 4.3;    // protrusion in -X past the panel face
bore_dia    = 3.5;    // plug bore

// ---- Pins ------------------------------------------------------------------
pin_w       = 0.8;    // tab thickness
pin_l       = 2.5;    // tab width across
pin_drop    = 3.2;    // how far below z = 0 the tab reaches

// Pad locations in footprint local coordinates.
pin1 = [ 6.05,  0.0 ];   // Sleeve
pin2 = [18.30, -5.1 ];   // Ring
pin3 = [18.30,  0.0 ];   // Tip
pin4 = [18.30,  5.1 ];   // Shunt (normalled to tip)

// ---------------------------------------------------------------------------

module body_block() {
    // Full-width lower body...
    translate([0, -body_wid / 2, 0])
        cube([body_len, body_wid, body_tall]);
}

module housing_relief() {
    // ...with the corners above the 7.8 housing square cut back to 10 wide,
    // which is what the datasheet front view shows.
    for (s = [-1, 1])
        translate([-0.1, s > 0 ? house_wid / 2 : -house_wid / 2 - body_wid, house_tall])
            cube([body_len + 0.2, body_wid, body_tall]);
}

module barrel() {
    rotate([0, 90, 0])
        translate([0, 0, -barrel_out])
            cylinder(h = barrel_out + 2.0, d = barrel_dia);
}

module bore() {
    // Plug bore, drilled from the panel face back into the body.
    translate([-barrel_out - 0.5, 0, 0])
        rotate([0, 90, 0])
            cylinder(h = barrel_out + 14.0, d = bore_dia);
}

module pin_tab(pos, along_x) {
    // Flat tab dropping through the board. `along_x` orients the 2.5 mm
    // dimension along X (pins 1 and 3) rather than along Y (pins 2 and 4).
    sz = along_x ? [pin_l, pin_w, pin_drop + 1.2]
                 : [pin_w, pin_l, pin_drop + 1.2];
    translate([pos[0] - sz[0] / 2, pos[1] - sz[1] / 2, -pin_drop])
        cube(sz);
}

module jack() {
    union() {
        difference() {
            union() {
                difference() {
                    body_block();
                    housing_relief();
                }
                translate([0, 0, bore_z]) barrel();
            }
            translate([0, 0, bore_z]) bore();
        }
        pin_tab(pin1, true);
        pin_tab(pin2, false);
        pin_tab(pin3, true);
        pin_tab(pin4, false);
    }
}

// KiCad's 3D model frame has +Y opposite the footprint's +Y, so mirror Y
// on export. Everything above is authored in footprint coordinates.
module kicad_frame() { mirror([0, 1, 0]) children(); }

kicad_frame() jack();
