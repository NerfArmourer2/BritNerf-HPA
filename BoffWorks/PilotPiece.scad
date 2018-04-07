/*License Info: (c) Mike "Boff" Harratt 2018
Some Rights Reserved - Available under Attribution-NonCommercial-ShareAlike 4.0 International License

Basically, you can remix and edit this for non-commerical purposes i.e. making your own for yourself but not for sale then files you make changes to must be available under the same license.

Parts list:
Power Ram:
> Forward cap
> Power Tube Cap
> Rear piston
>> Piston head
>> Piston core w/bolt hole
>> O-Ring collar
>> Piston body w/sear cut out
> Actuator Arm
> 

*/

//$fn = 128;

//Global Variables
BT4_LENGTH = 49.25;
BT4_TOP_DIAMETER = 23.21;
BT4_BOTTOM_DIAMETER = 22.5;

POWER_TUBE_ALU_OD = 10;

/*
Master Bolt Types:
Allows you to pre-select the type of bolt used by default in each of the areas
-> Master Strutucal Bolt is the main construction bolt defaults to M3
-> Power Tube Bolt is the nuts and bolts used in the power tube, defaults to M2

-> BOLT_TYPE Arguements are as follows: 
--> HEX | CSK | RAISEDCSK | PANHEAD | CHEESEHEAD | CAPSCREW | CSKSOCKETSCREW

-> NUT_TYPE Arguments are as follows:
--> NORMAL | NYLOC

*/

//Master Structural Bolt Configuration
MSB_THREAD = 3;
MSB_BOLT_TYPE = "CAPSCREW";
MSB_BOLT_TYPE = "NYLOC";

//Power Tube Bolt Configuration
PTB_THREAD = 2;
MSB_BOLT_TYPE = "PANHEAD";
MSB_NUT_TYPE = "NYLOC";

//Power Ram Tube Configuration
POWER_RAM_OD = 32;
POWER_RAM_WALL = 2;

//Interface (Power Tube Clamp to Forward Power Tube) O Ring Dimensons
INTERFACE_O_RING_THICKNESS = 1.5;
INTERFACE_O_RING_DIAMETER = POWER_TUBE_ALU_OD + INTERFACE_O_RING_THICKNESS / 0.5;

//Power Tube O-Ring Configuration
POWER_TUBE_O_RING_THICKNESS = 2;
POWER_TUBE_O_RING_DIAMETER = 10;
NUMBER_POWER_TUBE_O_RINGS = 2;


//Master Wall Thickness
//Set the master wall thickness for the blaster
SWT = 3; //Standard wall thickness
NWT = 1.5; //Narrow wall thickness

module BT4_Geometry()
{
    
    cylinder(d1 = BT4_TOP_DIAMETER, d2 = BT4_BOTTOM_DIAMETER, h = BT4_LENGTH);
    
}


module Forward_Power_Tube()
{
    //Geometry for the forward power tube
    // TO DO: Drill pilot hole for BT4 valve

    O_RING_COLLAR_HEIGHT = INTERFACE_O_RING_THICKNESS + SWT * 2;
    
    POWER_TUBE_CHAMFER_THICKNESS = 3;
    PISTON_HEAD_REST_THICKNESS = 3;
    
    VALVE_COLLAR_Z_LINE = O_RING_COLLAR_HEIGHT + POWER_TUBE_CHAMFER_THICKNESS;
    PISTON_HEAD_REST_Z_LINE = VALVE_COLLAR_Z_LINE + BT4_LENGTH;
    REAR_PISTON_COLLAR_Z_LINE = PISTON_HEAD_REST_Z_LINE + PISTON_HEAD_REST_THICKNESS;
    
    
    difference()
    {
        union()
        {
            
            //Interface Collar Geometry
            cylinder(d = POWER_TUBE_ALU_OD + SWT, h = O_RING_COLLAR_HEIGHT);
            
            //Chamfer Geometry
            translate([0, 0, O_RING_COLLAR_HEIGHT])
            {
                cylinder(d1 = POWER_TUBE_ALU_OD + SWT, d2 = BT4_TOP_DIAMETER + SWT, h = POWER_TUBE_CHAMFER_THICKNESS);
            }
            
            //Valve Collar Geometry
            translate([0, 0, VALVE_COLLAR_Z_LINE])
            {
                cylinder(d = SWT + BT4_TOP_DIAMETER, h = BT4_LENGTH);
            }
            
            //Piston Head Rest Geometry
            translate([0, 0, PISTON_HEAD_REST_Z_LINE])
            {
                cylinder(d = SWT + BT4_TOP_DIAMETER, h = PISTON_HEAD_REST_THICKNESS);
            }           
            
            //Rear Piston Collar Geometry
            translate([0, 0, REAR_PISTON_COLLAR_Z_LINE])
            {
                cylinder(d = SWT + BT4_TOP_DIAMETER, h = POWER_TUBE_CHAMFER_THICKNESS);
            }
            
            //Bracing geometry
                        
            BRACE_OD = POWER_RAM_OD - POWER_RAM_WALL;
            BRACE_ID = SWT + BT4_TOP_DIAMETER;
            
            BRACE_WALL = BRACE_OD - BRACE_ID;
            
            BRACE_OFFSET = 10; //Space between the two bracing walls
            
            BRACE_CENTRE_POINT = PISTON_HEAD_REST_Z_LINE / 2;
            
            translate([0, 0, BRACE_CENTRE_POINT])
            {
                for(i = [-1 : 1 : 1])
                {
                    translate([0, 0, i * BRACE_OFFSET])
                    {
                        cylinder(d1 = BRACE_ID, d2 = BRACE_OD, h = BRACE_WALL);
                    }
                }
            }
                        
        }
        
        //Interface Collar Geometry
        cylinder(d = POWER_TUBE_ALU_OD, h = VALVE_COLLAR_Z_LINE);
        
        //Chamfer Geometry
        translate([0, 0, VALVE_COLLAR_Z_LINE]) 
        {
            cylinder(d = BT4_TOP_DIAMETER, h = BT4_LENGTH);
        }

        //Piston Head Rest Geometry
        translate([0, 0, PISTON_HEAD_REST_Z_LINE])
        {
            cylinder(d = BT4_TOP_DIAMETER, h = PISTON_HEAD_REST_THICKNESS);
        }   

        //Rear Piston Collar Geometry
        translate([0, 0, REAR_PISTON_COLLAR_Z_LINE]) 
        {
            cylinder(d1 = BT4_TOP_DIAMETER, d2 = BT4_TOP_DIAMETER + NWT, h = POWER_TUBE_CHAMFER_THICKNESS);
        }

        //O-Ring Grooves
        translate([0, 0, O_RING_COLLAR_HEIGHT / 2])
        {
            torus(INTERFACE_O_RING_DIAMETER, INTERFACE_O_RING_THICKNESS);
        }        
    }
    
}


module Power_Tube_Clamp()
{
       
    O_RING_COLLAR_HEIGHT = INTERFACE_O_RING_THICKNESS + SWT * 2;
    POWER_TUBE_O_RING_COLUMN_HEIGHT = (SWT * 2 + POWER_TUBE_O_RING_THICKNESS) * NUMBER_POWER_TUBE_O_RINGS;
    
    POWER_TUBE_CLAMP_HEIGHT = O_RING_COLLAR_HEIGHT + POWER_TUBE_O_RING_COLUMN_HEIGHT;
    POWER_TUBE_CLAMP_DIAMETER = POWER_TUBE_ALU_OD + (SWT * 2);

    difference()
    {
        //Main Clamp Body
        cylinder(d = POWER_TUBE_CLAMP_DIAMETER, h = POWER_TUBE_CLAMP_HEIGHT);
        
        //Forward Power Tube Interface Gemoetry
        //To do: Add O Ring interface groove
        cylinder(d = POWER_TUBE_ALU_OD + SWT, O_RING_COLLAR_HEIGHT);
        
        //Alu Power Tube Interface
        //To do: Securing O Ring grooves
        cylinder(d = POWER_TUBE_ALU_OD, h = POWER_TUBE_CLAMP_HEIGHT);
        
        //O-Ring Grooves
        translate([0, 0, O_RING_COLLAR_HEIGHT / 2])
        {
            torus(INTERFACE_O_RING_DIAMETER, INTERFACE_O_RING_THICKNESS);
        }  
               
        translate([0, 0, O_RING_COLLAR_HEIGHT + SWT])
        {
            for(i = [1 : 1 : NUMBER_POWER_TUBE_O_RINGS])
            {
                translate([0, 0, i * (POWER_TUBE_O_RING_THICKNESS + SWT)])
                {
                    torus(POWER_TUBE_O_RING_DIAMETER, POWER_TUBE_O_RING_THICKNESS);
                }
            }       
        }
        
        //Bolt Holes
        for(i = [0 : 1])
        {
            mirror([i, 0, 0])
            {
                translate([(POWER_TUBE_CLAMP_DIAMETER / 2) - NWT, POWER_TUBE_CLAMP_DIAMETER / 2, POWER_TUBE_CLAMP_HEIGHT / 2])
                {
                    rotate([90, 90, 0])
                    {
                        cylinder(d = PTB_THREAD, h = POWER_TUBE_CLAMP_DIAMETER);
                    }
                }
            }
        }
        
        //Halving cube
        translate([-POWER_TUBE_CLAMP_DIAMETER / 2, 0, 0])
        {
            cube([POWER_TUBE_CLAMP_DIAMETER, POWER_TUBE_CLAMP_DIAMETER, POWER_TUBE_CLAMP_HEIGHT]);
        }
        
    }
    
}

module torus(d, t)
{
    rotate_extrude(angle = 360, convexity = 10)
    {
        translate([d / 2, 0, 0])
        {
            circle(r = t/2);
        }
    }
}

// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}


module Bolt_Geometry(THREAD_SIZE, THREAD_LENGTH, HEAD_TYPE, FLUSH)
{
    
    // HEAD_TYPE: HEX | CSK | RAISEDCSK | PANHEAD | CHEESEHEAD | CAPSCREW | CSKSOCKETSCREW | NUTTRAP | NYLOCTRAP
    // Fastening Geometry from here: http://www.metrication.com/engineering/fastener.html
    
    union()  
    {
        if(HEAD_TYPE == "HEX")
        {
            THREAD_Z = THREAD_SIZE * 0.7;
            
            translate([0, 0, THREAD_Z / 2])
            {
                hexagon(THREAD_SIZE * 2, THREAD_Z);
            }
            
            Bolt_Thread(THREAD_Z, THREAD_SIZE, THREAD_LENGTH);
        }
        
        if(HEAD_TYPE == "CSK")
        {            
            THREAD_Z = THREAD_SIZE / 2;
            
            cylinder(d1 = THREAD_SIZE * 2, d2 = THREAD_SIZE, h = THREAD_Z);
            Bolt_Thread(THREAD_Z, THREAD_SIZE, THREAD_LENGTH); 
        }
        
        if(HEAD_TYPE == "RAISEDCSK")
        {
            
            THREAD_Z = THREAD_SIZE / 2;
            
            cylinder(d = THREAD_SIZE * 2, h = THREAD_SIZE /4);
            
            translate([0, 0, THREAD_SIZE / 4])
            {
                cylinder(d1 = THREAD_SIZE * 2, d2 = THREAD_SIZE, h = THREAD_Z);
            }
            
            Bolt_Thread(THREAD_Z + THREAD_SIZE / 4, THREAD_SIZE, THREAD_LENGTH); 
            
        }
        
        if(HEAD_TYPE == "PANHEAD")
        {
            THREAD_Z = 0.6 * THREAD_SIZE;

            cylinder(d = 2 * THREAD_SIZE, h = THREAD_Z);
            Bolt_Thread(THREAD_Z, THREAD_SIZE, THREAD_LENGTH);  
        }
        
        if(HEAD_TYPE == "CHEESEHEAD")
        {
            THREAD_Z = 0.6 * THREAD_SIZE;

            cylinder(d = 1.6 * THREAD_SIZE, h = THREAD_Z);
            Bolt_Thread(THREAD_Z, THREAD_SIZE, THREAD_LENGTH);  
        }
        
        if(HEAD_TYPE == "CAPSCREW")
        {
            THREAD_Z = 1.25 * THREAD_SIZE;

            cylinder(d = 1.5 * THREAD_SIZE, h = THREAD_Z);
            Bolt_Thread(THREAD_Z, THREAD_SIZE, THREAD_LENGTH);           
                 
        }
        
        if(HEAD_TYPE == "CSKSOCKETSCREW")
        {
        }
        
        if(HEAD_TYPE == "NUTTRAP")
        {
            //Produces a nut trap for a structural hexagonal nut, not a nylon locking nut
            THREAD_Z = THREAD_SIZE * 0.9;
            translate([0, 0, THREAD_Z / 2])
            {
                hexagon(THREAD_SIZE * 2, THREAD_Z);
            }
        } 
 
        if(HEAD_TYPE == "NYLOCTRAP")
        {
           if(THREAD_SIZE == 1.6) {THREAD_Z = 1.65;};
           if(THREAD_SIZE == 2) {THREAD_Z = 2.8;};
           if(THREAD_SIZE == 2.5) {THREAD_Z = 3.8;};
           if(THREAD_SIZE == 3) {THREAD_Z = 4;};
           if(THREAD_SIZE == 4) {THREAD_Z = 5;};
           if(THREAD_SIZE == 5) {THREAD_Z = 6.3;};
           if(THREAD_SIZE == 6) {THREAD_Z = 8;};
           if(THREAD_SIZE == 8) {THREAD_Z = 9.5;};
            
            //Produces a nut trap for a structural hexagonal nut, not a nylon locking nut
            THREAD_Z = THREAD_SIZE * 0.9;
            translate([0, 0, THREAD_Z / 2])
            {
                hexagon(THREAD_SIZE * 2, THREAD_Z);
            }       
        }
        
    }

}

module Bolt_Thread(Z, THREAD_SIZE, THREAD_LENGTH)
{
    //Module exists because of scoping problems for OpenSCAD, lifts the bolt thread by a specified amount
    
    translate([0, 0, Z])
    {
        cylinder(d = THREAD_SIZE, h = THREAD_LENGTH);
    }
}

// Rear Piston Variables
REAR_PISTON_DIAMETER = BT4_TOP_DIAMETER  - 0.5;
REAR_PISTON_O_RING_THICKNESS = 2;
REAR_PISTON_O_RING_DIAMETER = 15;

module Rear_Piston_Head()
{
    difference()
    {
        //cylinder(d = REAR_PISTON_DIAMETER, h = 12);
        Bolt_Geometry(3, 25, "NUTTRAP", "TRUE");
    }
}

//Rear_Piston_Head();
//Forward_Power_Tube();
Power_Tube_Clamp();