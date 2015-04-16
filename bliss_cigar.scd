s.boot;

SynthDef(\gh, {
	arg del=2, damp=0, size=1, diff=0.707, fb=0.9, moddepth=0.1, modfreq=2, gate=1;
	var source, sig, env;
	env = EnvGen.ar(Env.asr(releaseTime:0.2), gate, doneAction:2);
	source = SoundIn.ar(0);
	sig = Greyhole.ar(source, del, damp, size, diff, fb, moddepth, modfreq);
	Out.ar(0, sig*env);
}).add;

a = Synth(\gh);
a.set(\del, 0.5, \damp, 0.5, \size, 0.1, \diff, 0.1, \fb, 0.7, \moddepth, 0.5, \modfreq, 5);
a.set(\gate, 0);