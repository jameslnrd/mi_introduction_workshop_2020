import("stdfaust.lib");
import("mi.lib");

in1 = button("Force Impulse"): ba.impulsify;  	//write a specific force input signal operation here
in2 = hslider("Stiffness", 0.01, 0, 0.1, 0.0001):si.smoo; 	//write a specific parameter signal operation here
in3 = hslider("Damping", 0.0001, 0, 0.005, 0.000001):si.smoo; 	//write a specific parameter signal operation here

OutGain = 0.05;

K = in2;
Z = in3;

model = (
	osc(1., K, Z, 0, 0., 0.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
		par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0) = /* routed positions */ /* outputs */ m0;
	RoutingLinkToMass(p_out1, f_in1) = /* routed forces  */ f_in1, /* pass-through */ p_out1;
	nbMass = 1;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain);
