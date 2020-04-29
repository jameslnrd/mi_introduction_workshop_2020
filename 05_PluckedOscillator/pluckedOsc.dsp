import("stdfaust.lib");
import("mi.lib");

in1 = hslider("Pluck Position", 0, -1, 1, 0.001):si.smoo; 	//write a specific position input signal operation here

OutGain = 1;

model = (
	osc(1., 0.1, 0.0003, 0, 0., 0.),
	posInput(1.):
	RoutingMassToLink :
	nlPluck(0.5, 0.1, 0.001, 0., 1.),
	par(i, nbOut, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1) = /* routed positions */ m0, m1, /* outputs */ m0, m1;
	RoutingLinkToMass(l0_f1, l0_f2, p_out1, p_out2) = /* routed forces  */ l0_f1, l0_f2, /* pass-through */ p_out1, p_out2;
	nbMass = 2;
	nbOut = 2;
};
process = in1 : model:*(OutGain), *(OutGain);