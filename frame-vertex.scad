// PRUSA Mendel  
// Frame vertex
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

// Based on http://www.thingiverse.com/thing:2003 aka Viks footed 
// frame vertex, which is based on http://www.thingiverse.com/thing:1780 
// aka Tonokps parametric frame vertex
// Thank you guys for your great work

include <configuration.scad>

//Vertex Options
//==================

vertex_height=threaded_rod_diameter+threaded_rod_vertical_clearance*2;
FN=32;

hor_hole_seperation = threaded_rod_diameter*2+threaded_rod_horizontal_clearance*2;


//Polygon verticies
//==================
mid_l = 35;
mid_w = 25;

bot_l = 10;
bot_w = 10;


top_d = nut_diameter+nut_clearance;
top_s = (mid_w*sin(vert_angle)+top_d);
top_w = mid_w;


top_p1 = [mid_w/2+top_d*sin(vert_angle) , mid_l+top_d*cos(vert_angle)];
top_p2 = [mid_w/2+top_d*sin(vert_angle) -top_w*cos(vert_angle) , mid_l+top_d*cos(vert_angle)+top_w*sin(vert_angle)];
top_p3 = [mid_w/2-top_w*cos(vert_angle),mid_l+top_w*sin(vert_angle)];

translate ([0,0,vertex_height/2])difference() 
{
	union () {
//		dxf_linear_extrude(file = "vertex-body-fixed-qcad.dxf",height=vertex_height,center=true);
		//import_stl("vertex-body-fixed.stl");
		linear_extrude(height=vertex_height, center=true) {
			polygon(
				points=[
					[-mid_w/2, mid_l], [-mid_w/2, 0], [-bot_w/2,-bot_l],

					[bot_w/2,-bot_l], [mid_w/2,0], [mid_w/2,mid_l],
					top_p1, top_p2, top_p3
					],

				paths=[[0,1,2,3,4,5,6,7,8]]);

		}
	}
	
	// Horizontal holes
	zhole(threaded_rod_diameter);
	translate([0, hor_hole_seperation]) zhole(threaded_rod_diameter, 200); 

	// Frame triangle horizontal hole
	translate([0,hor_hole_seperation/2]) xteardrop(threaded_rod_diameter, 200);

	// Frame triangle angled hole
	translate([mid_w/2+top_d*sin(vert_angle)/2 , mid_l+top_d*cos(vert_angle)/2])  rotate(180-vert_angle) xteardrop(threaded_rod_diameter,200);

}


module zhole(diameter) cylinder(h=100,r=(diameter/2),center=true,$fn=FN); 

module xteardrop(diameter,length) rotate(a=-90,v=[0,1,0]) rotate(a=-90,v=[0,0,1]) zteardrop(diameter,length);

module yteardrop(diameter,length) rotate(a=90,v=[1,0,0]) zteardrop(diameter,length);

module zteardrop(diameter,height)
{
	rotate(a=0, v=[0,0,1]) union()
	{
		//translate([0,0,-height/2]) cube(size=[diameter/2,diameter/2,height],center=false);
		rotate(a=22.5, v=[0,0,1])cylinder(r=diameter/2, h = height,center=true,$fn=FN);
	}
}

module vertex_foot() {
	difference () {
		union () {
			cube([18,4,vertex_height],center=true);
			translate ([-5,8,0]) cube([5,18,vertex_height],center=true);
			translate ([5,9,0]) cube([5,18,vertex_height],center=true);
		}
		//translate ([0,8,0]) xteardrop(7,200);
	}
}
