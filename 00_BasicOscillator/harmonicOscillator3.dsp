import("stdfaust.lib");
import("mi.lib");

in1 = button("Frc Input 1"): ba.impulsify * 0.25;  	//write a specific force input signal operation here

OutGain = 1;

model = (
	mass(1., 0, 0., 0.),
	ground(0.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	spring(0.1, 0., 0.),
	damper(0.0003, 0., 0.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1) = /* routed positions */ m1, m0, m1, m0, /* outputs */ m0;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, p_out1, f_in1) = /* routed forces  */ f_in1 + l0_f2 + l1_f2, l0_f1 + l1_f1, /* pass-through */ p_out1;
	nbMass = 2;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain);