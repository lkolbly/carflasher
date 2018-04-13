PCB_LENGTH = 1.68*25.4;
PCB_WIDTH = 0.78*25.4;

$fn=100;

//cube([PCB_LENGTH, PCB_WIDTH, 0.5*25.4]);

translate([-10,10,0]) rotate([0,0,0]) {
    // Batteries
    //cylinder(5, 6, 6);
    //translate([0,0,6]) cylinder(5, 6, 6);

    // Battery holder
    difference() {
        cylinder(12, 7, 7);
        cylinder(12, 6.1, 6.1);
        translate([-12,-50,0]) cube([10, 100, 100]);
    }

    difference() {
        union() {
            // Clasp on bottom
            translate([-4,-5,-1]) cube([14,10,1]);
        
            // Clasp on top
            translate([-4,-5,12]) cube([14, 10, 1]);
        }

        translate([-2,-1.5,-50]) cube([2,3,100]);
        translate([2,-1.5,-50]) cube([2,3,100]);
    }
}

// The steering wheel positive
translate([0,-3,5]) difference() {
    translate([0,-18,2.5]) rotate([0,90,0]) cylinder(40, 20,20);
    translate([0,-30-18,-25]) cube([40, 36,50]);

    // The steering wheel negative
    translate([-40,-18,7]) rotate([0,90,0]) hull() {
        cylinder(100, 27.32/2, 27.32/2);
        translate([36-27.32,0,0]) cylinder(100, 27.32/2, 27.32/2);
    }
    
    // The holes for the zipties
    translate([5,-2,-50]) cube([6, 3, 100]);
    translate([30,-2,-50]) cube([6, 3, 100]);
    
    // Cut off the bottom part so it prints flat
    translate([0,-50,-106]) cube([100,100,100]);
}

// The PCB mounting posts
translate([0.09*25.4, (0.78-0.69)*25.4, 0]) cylinder(4, 0.07*25.4, 0.07*25.4);
translate([1.59*25.4, (0.78-0.09)*25.4, 0]) cylinder(4, 0.07*25.4, 0.07*25.4);

// The box holding the PCB
difference() {
    translate([-1.5, -1.5, -1]) cube([PCB_LENGTH+3, PCB_WIDTH+3, 13]);
    translate([-0.5, -0.5, 0]) cube([PCB_LENGTH+1, PCB_WIDTH+1, 13]);
    
    // Hole for the battery wire
    translate([3,9,-50]) cube([2,2,100]);
    
    // Holes for the two contact wires
    translate([2, 0, 0]) cube([2, 100, 2]);
    translate([2, 0, 7]) cube([2, 100, 2]);
}

// The trigger switch
translate([0, PCB_WIDTH+4, -1]) {
    cube([40, 1, 6]);
    
    // The pivot
    translate([40-5, -3, 0]) cube([5, 3, 6]);
    
    // The contact
    translate([0, -1, 0]) cube([5, 2, 10]);
}
