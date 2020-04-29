import("stdfaust.lib");
import("mi.lib");

in1 = button("Hammer Input Force"): ba.impulsify* -0.1;  	//write a specific force input signal operation here

OutGain = 1;

nlK = hslider("non-linear stiffness", 0.005, 0., 0.1, 0.0001);

model = (
	mass(1., 0, 0., 0.),
	ground(0.),
	mass(0.3, 0, 1., 1.),
	ground(1.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	nlSpringDamperClipped(0.03, nlK, 0.8, 0.0002, 0., 0.),
	springDamper(0.0001, 0.05, 1., 1.),
	collision(0.1, 0.001, 0, 0., 1.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1, m2, m3) = /* routed positions */ m1, m0, m3, m2, m0, m2, /* outputs */ m0;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, l2_f1, l2_f2, p_out1, f_in1) = /* routed forces  */ l0_f2 + l2_f1, l0_f1, f_in1 + l1_f2 + l2_f2, l1_f1, /* pass-through */ p_out1;
	nbMass = 4;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain);