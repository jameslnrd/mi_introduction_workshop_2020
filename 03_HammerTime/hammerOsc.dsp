import("stdfaust.lib");
import("mi.lib");

in1 = button("Frc Input 1"): ba.impulsify * -0.1;  	//write a specific force input signal operation here

OutGain = 1;

model = (
	osc(1., 0.1, 0.0003, 0, 0., 0.),
	mass(0.3, 0, 1., 1.),
	ground(1.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	springDamper(0.0001, 0.05, 1., 1.),
	collision(0.1, 0.001, 0, 0., 1.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1, m2) = /* routed positions */ m2, m1, m0, m1, /* outputs */ m0, m1;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, p_out1, p_out2, f_in1) = /* routed forces  */ l1_f1, f_in1 + l0_f2 + l1_f2, l0_f1, /* pass-through */ p_out1, p_out2;
	nbMass = 3;
	nbFrcIn = 1;
	nbOut = 2;
};
process = in1 : model:*(OutGain), *(OutGain);