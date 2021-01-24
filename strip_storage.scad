/*
User defined variables:
*/

cfgStripDiameter = 100;
cStripWidth = 10;
cStripThickness = 2;

//internal tweak variables
cWallThickness = 2;
cReflectorOffset = 10;
cReflectorHole = 0.8;
cFilletRadius=2;
cStripWidthClearance = 2;

cClampBiasFromFront = 10;
cClampsDistance = 30;

Square_size = cfgStripDiameter + cWallThickness*2;
//square(size = [Square_size,Square_size], center = true);
cFrontEdge = cfgStripDiameter/2 + cWallThickness;
cTopEdge = cfgStripDiameter/2 + cWallThickness;
cBottomEdge = -cTopEdge;

module base_internals() {
hull($fn=200) {
RadiusCenterOffset = Square_size/2 - cFilletRadius;
translate([RadiusCenterOffset,RadiusCenterOffset])
circle(r=cFilletRadius,$fn=120);
translate([RadiusCenterOffset,-RadiusCenterOffset])
circle(r=cFilletRadius);

circle(d=cfgStripDiameter+cWallThickness*2, $fn=200);
}    
}

//Clamp parameters
cClampRadius = 1;
cClampNeckRadius = 2;
cClampNeckWidth = 2;
cClampLength=10;
cClampWidth=4;
cClampHipOffset=cClampLength*0.55;
cClampNeckOffset=cClampLength*1/3;

module clamp_male_hull() {
    hull() {
    translate([0,-(cClampLength-cClampRadius)])
    circle(r=cClampRadius,$fn=20);
    HipX = cClampWidth/2-cClampRadius;
    translate([HipX,-cClampHipOffset])
    circle(r=cClampRadius,$fn=20);
    translate([-HipX,-cClampHipOffset])
    circle(r=cClampRadius,$fn=20);
    SquareH = 1;
    translate([-cClampWidth/2,-SquareH])
square(size = [cClampWidth,SquareH], center = false);
    }
}

module clamp_male_cutout() {
    XBias = cClampNeckWidth/2 + cClampNeckRadius;
    translate([XBias,-cClampNeckOffset])
    circle(r=cClampNeckRadius,$fn=40);
    translate([-XBias,-cClampNeckOffset])
    circle(r=cClampNeckRadius,$fn=40);
}
module clamp_male() {
difference() {
clamp_male_hull();
clamp_male_cutout();
}
}



module base() {
    base_internals();
    clamp1X = cFrontEdge-cClampBiasFromFront;
    clamp2X = clamp1X - cClampsDistance;
    translate([clamp1X,cBottomEdge])
    clamp_male();
    translate([clamp2X,cBottomEdge])
    clamp_male();
}



module main_cutouts() {
    stripCutTop = cTopEdge - cWallThickness;
    stripCutBottom = stripCutTop - cStripThickness;
    polygon( points=[[0,stripCutTop],[cFrontEdge,stripCutTop],[cFrontEdge,stripCutBottom],[0,stripCutBottom]]);
    
    circle(d=cfgStripDiameter,$fn=200);
    
    reflectorRightTopX = cFrontEdge - cReflectorOffset;
    reflectorLeftTopX = reflectorRightTopX - 1.41*cReflectorHole;
    reflectorRightBottomX = reflectorRightTopX - cWallThickness;
    reflectorLeftBottomX = reflectorLeftTopX - cWallThickness;
    reflectorTopY = cTopEdge;
    reflectorBottomY = cTopEdge - cWallThickness;
    polygon( points=[[reflectorLeftTopX,reflectorTopY],[reflectorRightTopX,reflectorTopY],[reflectorRightBottomX,reflectorBottomY],[reflectorLeftBottomX,reflectorBottomY]]);
}

module main() {
    difference() {
        base();
        main_cutouts();
    }
}

linear_extrude(height = cWallThickness)
base();
translate([0,0,cWallThickness])
linear_extrude(height = cStripWidth + cStripWidthClearance)
main();