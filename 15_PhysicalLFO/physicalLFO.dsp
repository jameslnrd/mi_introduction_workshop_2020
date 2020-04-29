declare name    "Physical LFO";
declare author  "James Leonard";
declare date    "April 2020";

/* ========= DESCRITPION =============

You can use physical models for other things than sythesizing "acoustical" sounds!
Here, we use a very floppy string as an LFO generator to modulate a white noise signal.
    - inputs: force impulse to excite the string.
    - outputs: position of one mass of the string (used to modulate the white noise)
    - controls: string stiffness and damping.

Note: when excited, the string first displays strong harmonic content, resulting in complex
modulation patterns that die down as damping tends to return to the fundamental frequency.
*/

import("stdfaust.lib");
import("mi.lib");

gateT = button("Excite String"):ba.impulsify;
in1 = gateT * 0.1; 

OutGain = hslider("output gain", 0.01, 0, 0.02, 0.00001);

str_M = 1.0;
str_K = hslider("string stiffness", 0.000001, 0.0000001, 0.00001, 0.0000001);
str_Z = hslider("string damping", 0.0001, 0, 0.002, 0.00001);


model = (
	ground(0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	mass(str_M, 0, 0., 0.),
	ground(0.),
	par(i, nbFrcIn,_):
	RoutingMassToLink ,
	par(i, nbFrcIn,_):
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	springDamper(str_K, str_Z, 0., 0.),
	par(i, nbOut+nbFrcIn, _):
	RoutingLinkToMass
)~par(i, nbMass, _):
par(i, nbMass, !), par(i, nbOut , _)
with{
	RoutingMassToLink(m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11) = /* routed positions */ m0, m1, m1, m2, m2, m3, m3, m4, m4, m5, m5, m6, m6, m7, m7, m8, m8, m9, m9, m10, m10, m11, /* outputs */ m2;
	RoutingLinkToMass(l0_f1, l0_f2, l1_f1, l1_f2, l2_f1, l2_f2, l3_f1, l3_f2, l4_f1, l4_f2, l5_f1, l5_f2, l6_f1, l6_f2, l7_f1, l7_f2, l8_f1, l8_f2, l9_f1, l9_f2, l10_f1, l10_f2, p_out1, f_in1) = /* routed forces  */ l0_f1, f_in1 + l0_f2 + l1_f1, l1_f2 + l2_f1, l2_f2 + l3_f1, l3_f2 + l4_f1, l4_f2 + l5_f1, l5_f2 + l6_f1, l6_f2 + l7_f1, l7_f2 + l8_f1, l8_f2 + l9_f1, l9_f2 + l10_f1, l10_f2, /* pass-through */ p_out1;
	nbMass = 12;
	nbFrcIn = 1;
	nbOut = 1;
};
process = in1 : model:*(OutGain)*no.noise;