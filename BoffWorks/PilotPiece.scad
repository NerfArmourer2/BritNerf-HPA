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

//Global Variables
BT4_LENGTH = 49.25;
BT4_TOP_DIAMETER = 23.21;
BT4_BOTTOM_DIAMETER = 22.5;

module BT4_Geometry()
{
    
    cylinder(d1 = BT4_TOP_DIAMETER, d2 = BT4_BOTTOM_DIAMETER, h = BT4_LENGTH);
    
}

module Forward_Power_Tube()
{
    //Geometry for the forward power tube
    
    POWER_TUBE_ALU_OD = 20;
    
    union()
    {
        //cylinder(d = );
        
    }
    
}

// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}


module Bolt_Geometry(THREAD_SIZE, THREAD_LENGTH, HEAD_TYPE, FLUSH)
{
    
    // HEAD_TYPE: BOLT | CSK | RAISEDCSK | PANHEAD | CHEESEHEAD | CAPSCREW | CSKSOCKETSCREW | NUTTRAP | NYLOCTRAP
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
           if(THREAD_SIZE = 1.6) THREAD_Z = 1.65;
           if(THREAD_SIZE = 2) THREAD_Z = 2.8;
           if(THREAD_SIZE = 2.5) THREAD_Z = 3.8;
           if(THREAD_SIZE = 3) THREAD_Z = 4;
           if(THREAD_SIZE = 4) THREAD_Z = 5;
           if(THREAD_SIZE = 5) THREAD_Z = 6.3;
           if(THREAD_SIZE = 6) THREAD_Z = 8;
           if(THREAD_SIZE = 8) THREAD_Z = 9.5;
            
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

Rear_Piston_Head();