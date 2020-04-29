declare name    "Boucing On an Oscillator";
declare author  "James Leonard";
declare date    "April 2020";

/* ========= DESCRITPION =============

A dropped mass falling onto an oscillator (due to gravity)
    - inputs: none, just gravity doing its thing.
    - outputs: oscillator position.
    - controls: none.

Note: Beware, if using 32 bit precision gravity forces can become so small they are truncated in calculations !
*/

import("stdfaust.lib");
import("mi.lib");


OutGain = 100;

grav = 0.002;
K = 0.04;

model = (
	osc(1., K, 0.0003, 0, 0., 0.),
	mass(1, grav/ ma.SR, 3., 3.):
	RoutingMassToLink :
	collision(0.1, 0.02, 0, 0., 3.),
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
process = model:*(OutGain);
