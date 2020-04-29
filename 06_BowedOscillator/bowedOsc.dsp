import("stdfaust.lib");
import("mi.lib");

in1 = hslider("Bow Position", 0, 0, 100, 0.001):si.smoo:si.smoo:si.smoo; 	//Need very smooth position data here !

OutGain = 20;

type = 0;

model = (
	osc(1., 0.1, 0.0003, 0, 0., 0.),
	posInput(1.):
	RoutingMassToLink :
	nlBow(1.2, 0.001, type, 0., 1.),
	par(i, nbOut, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1) = /* routed positions */ m0, m1, /* outputs */ m0;
	RoutingLinkToMass(l0_f1, l0_f2, p_out1) = /* routed forces  */ l0_f1, l0_f2, /* pass-through */ p_out1;
	nbMass = 2;
	nbOut = 1;
};
process = in1 : model:*(OutGain);