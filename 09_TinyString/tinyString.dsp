import("stdfaust.lib");
import("mi.lib");

in1 = button("Force Impulse"): ba.impulsify;  	//write a specific force input signal operation here

OutGain = 0.6;

stiffness = 0.5;
damping = 0.0003;

model = (
	ground(0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	ground(0.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	springDamper(stiffness, damping, 0., 0.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1, m2, m3, m4, m5, m6, m7, m8, m9) = /* routed positions */ m0, m1, m1, m2, m2, m3, m3, m4, m4, m5, m5, m6, m6, m7, m7, m8, m8, m0, /* outputs */ m2;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, l2_f1, l2_f2, l3_f1, l3_f2, l4_f1, l4_f2, l5_f1, l5_f2, l6_f1, l6_f2, l7_f1, l7_f2, l8_f1, l8_f2, p_out1, f_in1) = /* routed forces  */ l0_f1 + l8_f2, l0_f2 + l1_f1, l1_f2 + l2_f1, l2_f2 + l3_f1, l3_f2 + l4_f1, l4_f2 + l5_f1, l5_f2 + l6_f1, f_in1 + l6_f2 + l7_f1, l7_f2 + l8_f1, 0, /* pass-through */ p_out1;
	nbMass = 10;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain);