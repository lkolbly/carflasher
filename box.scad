PCB_LENGTH = 1.68*25.4;
PCB_WIDTH = 0.78*25.4;

$fn=100;

//cube([PCB_LENGTH, PCB_WIDTH, 0.5*25.4]);

module box() {
    translate([-8,10,0]) rotate([0,0,0]) {
        // Batteries
        //cylinder(5, 6, 6);
        //translate([0,0,6]) cylinder(5, 6, 6);

        // Battery holder
        translate([0,0,-1]) difference() {
            cylinder(13, 7, 7);
            cylinder(13, 6.1, 6.1);
            translate([-13,-50,0]) cube([10, 100, 100]);
            translate([-1,-50,0]) rotate([0,35,0]) cube([10, 100, 100]);
        }

        difference() {
            union() {
                // Clasp on bottom
                translate([-4,-7,-1]) cube([14,14,1]);
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
    //translate([0.09*25.4, (0.78-0.69)*25.4, 0]) cylinder(4, 0.07*25.4, 0.07*25.4);
    //translate([1.59*25.4, (0.78-0.09)*25.4, 0]) cylinder(4, 0.07*25.4, 0.07*25.4);

    // The box holding the PCB
    difference() {
        translate([-1.5, -1.5, -1]) cube([PCB_LENGTH+3, PCB_WIDTH+3, 13]);
        
        // Shelf for the PCB to rest on
        translate([0.5, 0.5, 0]) cube([PCB_LENGTH-1, PCB_WIDTH-1, 13]);

        // Room for the entire PCB
        translate([-0.5, -0.5, 3]) cube([PCB_LENGTH+1, PCB_WIDTH+1, 13]);
        
        // Hole for the battery wire
        translate([3,9,-50]) cube([2,2,100]);
        
        // Holes for the two contact wires
        translate([40, 5, 0]) {
            cube([2, 100, 2]);
            translate([-7, 0, 0]) cube([2, 100, 2]);
        };
        translate([40, 5, 7]) {
            cube([2, 100, 2]);
            translate([-7, 0, 0]) cube([2, 100, 2]);
        }
    }

    // The trigger switch
    TRIGGER_SPACING = 7;
    translate([0, PCB_WIDTH+TRIGGER_SPACING, -1]) {
        cube([30+TRIGGER_SPACING, 1, 6]);
        
        // The pivot
        translate([0, -TRIGGER_SPACING + 1, 0]) cube([5, TRIGGER_SPACING, 6]);
        
        // The contact
        translate([30+TRIGGER_SPACING, -1, 0]) difference() {
            cube([5, 2, 11]);

            // notches for the contact metal
            translate([1.5,0,9]) cube([2, 100, 2]);

            translate([1.5,0,0]) cube([2, 100, 2]);
        }
    }
}

//
// The lid
//

module lid() {
    translate([-10,10,-2]) difference() {
        union() {
            translate([-4,-4,12]) cube([9, 8, 3]);
            translate([4,-4,14]) cube([5, 8, 1]);
        }

        translate([-2,-1.5,-50]) cube([2,3,100]);
        translate([2,-1.5,-50]) cube([2,3,100]);
    }

    difference() {
        union() {
            translate([-1.5,-1.5,12]) cube([PCB_LENGTH+3, PCB_WIDTH+3, 1]);
            
            // Inset
            translate([0,0,11]) cube([PCB_LENGTH, PCB_WIDTH, 1]);
            
            // Socket for the LED
            //1552,566
            translate([1.552*25.6,PCB_WIDTH-0.566*25.6,6]) cylinder(6, 4,4);
        }

        // Hole for the battery wire
        translate([3,9,-50]) cube([2,2,100]);
        
        // Hole for the LED
        translate([1.552*25.6,PCB_WIDTH-0.566*25.6,6]) cylinder(100, 3,3);
        
        // Slot for the transistors
        translate([29,2,0]) cube([7,PCB_WIDTH-4,100]);
        
        // Slot for the capacitor
        translate([5,1.5,0]) cube([5,10,100]);
        
        // Slot for the BDM cable
        // 90,280
        translate([(0.09-0.05)*25.6, PCB_WIDTH-(0.280+0.05)*25.6-0.5, 0]) cube([0.2*25.6,0.3*25.6+0.5,100]);
    }
}

//box();
translate([0,0,10]) lid();
