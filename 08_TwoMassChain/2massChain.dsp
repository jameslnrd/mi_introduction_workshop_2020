import("stdfaust.lib");
import("mi.lib");

in1 = button("Frc Input 1"): ba.impulsify;  	//write a specific force input signal operation here

OutGain = 0.1;

K1 = 0.1;
Z1 = 0.0003;
K2 = 0.1;
Z2 = 0.0003;

model = (
	ground(0.),
	mass(1., 0, 0., 0.),
	mass(1., 0, 0., 0.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	springDamper(K1, Z1, 0., 0.),
	springDamper(K2, Z2, 0., 0.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1, m2) = /* routed positions */ m0, m1, m1, m2, /* outputs */ m2;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, p_out1, f_in1) = /* routed forces  */ l0_f1, l0_f2 + l1_f1, f_in1 + l1_f2, /* pass-through */ p_out1;
	nbMass = 3;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain);