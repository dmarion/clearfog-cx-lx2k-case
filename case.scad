
show_base = true;
show_face = true;
show_lid = true;
show_board = false;

MINI_ITX_X = 170;
MINI_ITX_Y = 170;
MINI_ITX_HOLES_INCH =
    [ [ 0.3, 1.3 ], [ 6.5, 0.4 ], [ 0.3, 6.5 ], [ 6.5, 6.5 ] ];

HEIGHT = 95;

CORNER_POST_SIZE = 8;
CORNER_POST_HEIGHT = 15;

PCI_SLOT_WIDTH = 20;
PCI_SLOT_HEIGHT = 82;
BASE_X = MINI_ITX_X + 2 * CORNER_POST_SIZE + 24;
BASE_Y = MINI_ITX_Y + 2 * CORNER_POST_SIZE;
BASE_THICK = 1.5;
PCB_HEIGHT = 10;

FACE_X = BASE_X - CORNER_POST_SIZE;
FACE_Y = HEIGHT;
FACE_GAP = 1.5;
FACE_THICK = 1;
SLOT_HOLDER_THICK = 3;

LID_THICK = 2;

CORNER_POSTS = [[CORNER_POST_SIZE / 2, CORNER_POST_SIZE * 1.5],
                [CORNER_POST_SIZE / 2, BASE_Y - CORNER_POST_SIZE / 2],
                [BASE_X - CORNER_POST_SIZE / 2, CORNER_POST_SIZE * 1.5],
                [BASE_X - CORNER_POST_SIZE / 2, BASE_Y - CORNER_POST_SIZE / 2]];


FRONT_HOLES = [
    [ 26, 32, 29, "SFP+" ],
    [ 53, 10, 4, "CON" ],
    [ 65, 10, 4, "μBMC" ],
    [ 85, 17, 16, "ETH" ],
    [ 107, 15.5, 18, "USB" ],
    [ 127, 16, 4, "μSD" ],
    [ 147, 22, 13, "QSFP28" ],
];

module corner_post(a)
{
    x = a[0];
    y = a[1];
    s = CORNER_POST_SIZE;
    h = CORNER_POST_HEIGHT;
    th = HEIGHT;

    if (show_base)
        difference()
        {
            color("green") translate([ x - s / 2, y - s / 2, 0 ])
                cube([ s, s, h ]);
            translate([ x, y, -1 ]) cylinder(h = h + 2, r = 3.2 / 2, $fn = 18);
        }

    if (show_lid)
        difference()
        {
            color("lightgreen") translate([ x - s / 2, y - s / 2, h ])
                cube([ s, s, th - h ]);
            translate([ x, y, -1 ]) cylinder(h = th + 2, r = 1, $fn = 18);
        }
}

module mini_itx_post(a)
{
    x = a[0];
    y = a[1];
    s = CORNER_POST_SIZE;
    h = PCB_HEIGHT;
    color("red") translate([ s + x * 25.4, s + y * 25.4, 0 ]) difference()
    {
        cylinder(h = h, r = 3.5, center = false, $fn = 18);
        translate([ 0, 0, 1 ])
            cylinder(h = h, r = 1.6, center = false, $fn = 18);
    }
}

module
front_holder()
{
    s = CORNER_POST_SIZE;
    h = CORNER_POST_HEIGHT;
    p = PCB_HEIGHT;
    x = BASE_X;
    fx = FACE_X;
    t = FACE_GAP;
    th = HEIGHT;

    if (show_base)
        color("green") difference()
        {
            if (true) {
                cube([ s, s, h ]);
                translate([ x - s, 0, 0 ]) cube([ s, s, h ]);
                translate([ 0, s - 2 * t, 0 ]) cube([ x, 3 * t, p ]);
            }
            translate([ s / 2, s - t, -1 ]) cube([ fx, t, th + 2 ]);
        }
    if (show_lid)
        color("lightgreen") difference()
        {
            if (true) {
                translate([ 0, 0, h ])
                {
                    cube([ s, s, th - h ]);
                    translate([ x - s, 0, 0 ]) cube([ s, s, th - h ]);
                    translate([ 0, s - 2 * t, th - s - h ])
                        cube([ x, 3 * t, s ]);
                }
            }
            translate([ s / 2, s - t, -1 ]) cube([ fx, t, th + 2 ]);
        }
}

module base_grill(x, y)
{
    l = 120;
    g = 4;
    t = BASE_THICK;
    for (j = [-60:g * 2:60])
        translate([ x, y + j, -t / 2 ])
        {
            cube([ l, g, t + 2 ], center = true);
            for (i = [ -l / 2, l / 2 ])
                translate([ i, 0, 0 ])
                    cylinder(r = g / 2, h = 10, center = true, $fn = 18);
        }
}

module base(x, y)
{
    t = BASE_THICK;
    s = CORNER_POST_SIZE;
    if (show_base) {
        difference()
        {
            translate([ 0, 0, -t ]) color("lightgrey") cube([ x, y, t ]);
            base_grill(s + MINI_ITX_X / 2, s + MINI_ITX_Y / 2);
            for (a = CORNER_POSTS)
                translate([ a[0], a[1], -t - 1 ])
                    cylinder(h = t + 2, r = 5.8 / 2, $fn = 18);
        }
        for (i = MINI_ITX_HOLES_INCH)
            mini_itx_post(i);
        translate([ s + MINI_ITX_X - 4, 60, 0 ]) color("red")
            cube([ 4, 10, PCB_HEIGHT ]);
    }

    for (a = CORNER_POSTS)
        corner_post(a);

    front_holder();

    if (show_board)
        translate([ s, s, PCB_HEIGHT ]) color("pink")
            cube([ MINI_ITX_X, MINI_ITX_Y, 1.6 ]);
}

module
pci_card_holder()
{
    h = 3;
    difference()
    {
        linear_extrude(height = h)
            polygon(points = [ [ -6, 0 ], [ 30, 0 ], [ 24, 12 ], [ 0, 12 ] ],
                    paths = [[ 0, 1, 2, 3 ]]);
        translate([ 7, 5, -1 ]) cylinder(r = 1.6, h = h + 2, $fn = 18);
        translate([ 18, 8.5, 2 ]) cylinder(r = 1.6, h = h + 2, $fn = 18);
    }
}

module
face()
{
    t = FACE_THICK;
    t2 = SLOT_HOLDER_THICK;
    s = CORNER_POST_SIZE;
    pw = PCI_SLOT_WIDTH;
    ph = PCI_SLOT_HEIGHT;
    x = MINI_ITX_X + 1;

    difference()
    {
        cube([ FACE_X, FACE_Y, t ]);
        translate([ s / 2 + x - pw / 2, -1, -1 ]) cube([ pw, ph + 1, t + 2 ]);
        translate([ s / 2 + x + 1 - pw / 2, ph, -1 ])
            cube([ pw + 4, 3, t + 2 ]);

        for (a = FRONT_HOLES)
            translate([ s / 2 + a[0] - a[1] / 2, PCB_HEIGHT, -1 ])
                cube([ a[1], a[2], t + 2 ]);

        translate([ s + 10, FACE_Y - s - 10, -1 ]) cylinder(h = t + 2, r = 4.5);
    }
    translate([ s / 2 + x + pw / 2 + 5, ph - t2, t ]) rotate([ 90, 0, 180 ])
        pci_card_holder();

    translate([ 15, FACE_Y / 2 + 5, t ]) linear_extrude(height = 1)
        text("ClearFog CX Lx2K",
             font = "Liberation Sans:style=Bold Italic",
             valign = "center",
             halign = "left",
             size = 12,
             $fn = 18);

    f = "Liberation Sans:style=Bold";

    for (a = FRONT_HOLES)
        translate([ s / 2 + a[0], PCB_HEIGHT + a[2] + 2, t ])
            linear_extrude(height = 1) text(a[3],
                                            font = f,
                                            size = 3,
                                            halign = "center",
                                            valign = "baseline",
                                            $fn = 12);

    a = FRONT_HOLES[0];
    tx1 = s / 2 + a[0] - a[1] / 2 - 2;
    tx2 = s / 2 + a[0] + a[1] / 2 + 2;
    ty1 = 10 + 3 * a[2] / 4;
    ty2 = 10 + 1 * a[2] / 4;
    sz = 3;

    color("lightgrey") for (a =
                                [
                                    [ tx1, ty1, "0" ],
                                    [ tx1, ty2, "1" ],
                                    [ tx2, ty1, "2" ],
                                    [ tx2, ty2, "3" ],
                                ]) translate([ a[0], a[1], t ])
        linear_extrude(height = 0.5) text(a[2],
                                          font = f,
                                          size = sz,
                                          halign = "center",
                                          valign = "center",
                                          $fn = 12);
}

base(BASE_X, BASE_Y);

if (show_face)
    translate([ CORNER_POST_SIZE / 2, CORNER_POST_SIZE, 0 ])
        rotate([ 90, 0, 00 ]) face();

module
lid()
{
    bt = BASE_THICK;
    t = LID_THICK;
    x = BASE_X;
    y = BASE_Y;
    h = HEIGHT;
    s = CORNER_POST_SIZE;
    g = 5;

    translate([ 0, 0, -bt ]) difference()
    {
        linear_extrude(height = h + bt + t) offset(2, $fn = 18)
            square(size = [ x, y ]);
        translate([ 0, 0, -1 ]) cube([ x, y, bt + h + 1 ]);
        translate([ s, -bt - 1, -1 ]) cube([ x - 2 * s, bt + 2, h ]);

        for (j = [2 * s:g * 2:BASE_Y - 2 * s]) {
            // left and right grill
            for (i = [2 * s:g * 2:h - 2 * s])
                translate([ -t - 1, j, bt + i ]) rotate(
                    [ 0, 90, 0 ]) for (k = [ 0, g ]) translate([ k, k, 0 ])
                    cylinder(h = BASE_X + 2 * t + 2, r = g / 1.7, $fn = 12);

            // top grill
            for (i = [2 * s:g * 2:BASE_X - 2 * s])
                translate([ i, j, h + bt - 1 ]) for (k = [ 0, g ])
                    translate([ k, k, 0 ])
                        cylinder(h = t + 2, r = g / 1.7, $fn = 12);
        }
    }
}

if (show_lid) {
    color("cyan") lid();
}