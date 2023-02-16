include <lib.scad>


hole = 4; //hole diamter
rail_thk = 1.0;
rail_base = 27;
rail_hgt = 7.5;
rail_wid = 35;
rail_lip = 0.5 * (rail_wid - rail_base) + rail_thk;
slot_len = 18.0;
slot_wid = 6.3;
slot_c2c = 25.0;
slot_gap = slot_c2c - slot_len;
slot_hole_c2c = slot_len - slot_wid;
module make_din_rail( length ) {
  color("silver") {
  // draw the edges and lips
  translate([rail_hgt-rail_thk,0.5*rail_base-rail_thk,0]) 
    cube([rail_thk,rail_lip,length]);
  translate([0,0.5*rail_base-rail_thk,0]) 
    cube([rail_hgt,rail_thk,length]);;
  mirror([0,1,0]) {
    translate([rail_hgt-rail_thk,0.5*rail_base-rail_thk,0]) 
      cube([rail_thk,rail_lip,length]);
    translate([0,0.5*rail_base-rail_thk,0]) 
      cube([rail_hgt,rail_thk,length]);;
  }

  difference() {
    // base rail
    translate([0,-0.5*rail_base,0]) 
      cube([rail_thk,rail_base,length]);
    // holes
    for(z= [0:slot_c2c:length-0.5*slot_gap]) {
      translate([-0.5*rail_thk,0,z+0.5*slot_wid+0.5*slot_gap])
      rotate([0,90,0])  
      hull() {
        translate([-slot_hole_c2c,0,0])
          cylinder(h=2*rail_thk,d=slot_wid, $fn=30);
        cylinder(h=2*rail_thk,d=slot_wid, $fn=30);
      }
    }  
  }
  }
}

module place_din_rail(length=100) {
  rotate(-90,[1,0,0])
  rotate(-90,[0,0,1])
  make_din_rail(length);
}

module place( thing, align=[0,0,-1]) {
  translate([
    -align.x*0.5*thing.x, 
    -align.y*0.5*thing.y, 
    -align.z*0.5*thing.z])
    children();
}
module place_cube( thing, align=[0,0,-1]) {
  translate([
    -align.x*0.5*thing.x, 
    -align.y*0.5*thing.y, 
    -align.z*0.5*thing.z])
    cube(thing, center=true);
}
    
    

clamp_width = 15;
clamp_color = "darkolivegreen";
module make_clamp_base() {
  color(clamp_color)
  translate([0,0.5*clamp_width,0])
  difference() {
    rotate(90,[1,0,0])
      linear_extrude(height=clamp_width, convexity=10)
        import("din-rail-clamp.dxf");
    // screwdriver release slot/pocket
    box = [1.5, clamp_width-3, 5 ];
    translate([-18.6,-1,-13.8])
      place(box, [1,1,-1])
        cube(box, center=true);
  }
}
module print_clamp_base() {
  rotate(270,[1,0,0])
    translate([0,-0.5*clamp_width,0])
      make_clamp_base();
}


pca = [ 30, clamp_width, 6 ];
pca_dia = 15;
m3_insert_dia = 5;
m3_insert_deep = 5;
hole_spacing = 30;
hole_xposns = [ -0.5*hole_spacing, +0.5*hole_spacing ];
module make_panel_controller_adaptor() {
  make_clamp_base();
  color(clamp_color)
  difference() {
    union() { // make dog bone shape
      place_cube(pca, [0,0,-1]);
      for(x=hole_xposns) 
        translate([x,0,0])
          cylinder( d=pca_dia, h=pca.z );
    }
    for(x=hole_xposns)
      translate([x,0,pca.z-m3_insert_deep+0.01])
        cylinder( d=m3_insert_dia, h=m3_insert_deep );
  }
}
module print_panel_controller_adaptor() {
  rotate(270,[1,0,0])
    translate([0,-0.5*clamp_width,0])
      make_panel_controller_adaptor();
}

*translate([0,0,-16.5])
  place_din_rail(30);

* make_clamp_base();
*make_panel_controller_adaptor();
print_panel_controller_adaptor();

* print_clamp_base();
