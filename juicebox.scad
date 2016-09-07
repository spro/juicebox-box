TW = 5.7; // thickness
TA = 3.0;

kerf = 0.095;

P = kerf * 2 + 1;

s440 = 2.845/2;

wall = TW;

board_w = 56;
board_l = 85;
box_w = board_l + 15 + 2*wall;
box_l = board_l + 15 + 2*wall;
box_top_inset = 0;//TW;
box_h = 30;

corner = 10;

$fn = 24;

module round_rect(w, h, r) {
    hull() {
        translate([r, r]) circle(r);
        translate([w-r, r]) circle(r);
        translate([r, h-r]) circle(r);
        translate([w-r, h-r]) circle(r);
    }
}

function gray(i, a=1) = [i, i, i, a];
function brown(i, a=1) = [max(0.4-i/20, 0), max(0.2-i/20, 0), 0, a];

module ring(w, l, diff) {
    difference() {
        round_rect(w, l, corner);
        translate([diff, diff])
        round_rect(w - diff*2, l - diff*2, corner/2);
        /* square([w - diff*2, l - diff*2]); */
    }
}

// Board

translate([wall, wall])
linear_extrude(height=2)
square([board_w, board_l]);

// Wire
translate([wall, wall])
translate([0, board_l - 20, 4.5])
rotate([0, -90, 0])
color(gray(0.2))
cylinder(h=TW+2, r=3);

// Outside

color(brown(5))
translate([0, 0, -1])
linear_extrude(height=box_h)
ring(box_w, box_l, wall);

// Top piece

module grate() {
    n = 5;
    s = 8;
    r = 2;
    translate([-1 * (n - 1) * s / 2, -1 * (n - 1) * s / 2])
    for (x = [0:n-1]) {
        for (y = [0:n-1]) {
            translate([x * s, y * s])
            circle(r=r);
        }
    }
}

eps = 0.01;

color([0.7, 0, 0])
translate([eps, eps, box_h])
linear_extrude(height=TA)
difference() {
    round_rect(box_w-eps*2, box_l-eps*2, corner);
    translate([(box_w-eps*2)/2, (box_l-eps*2)/2])
    grate();
}

// Screws

outset = wall * 2;

translate([0, 0, 1])
difference() {
    r = 3;

    translate([0, 0, box_h+TA]) {
        translate([outset, outset])
        color([0, 0, 0])
        sphere(r=r);

        translate([box_w-outset, outset])
        color([0, 0, 0])
        sphere(r=r);

        translate([outset, box_l-outset])
        color([0, 0, 0])
        sphere(r=r);

        translate([box_w-outset, box_l-outset])
        color([0, 0, 0])
        sphere(r=r);
    }

    translate([0, 0, box_h+TA-r])
    linear_extrude(height=r)
    square([box_w, box_l]);
}
