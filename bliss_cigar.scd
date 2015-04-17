s.boot;

//GREYHOLE ANALOG TAPE DELAY
SynthDef(\gh, {
	arg del=2, damp=0, size=1, diff=0.707, fb=0.9, moddepth=0.1, modfreq=2, gate=1, rel=0.7;
	var source, sig, env;
	env = EnvGen.ar(Env.asr(releaseTime:rel), gate, doneAction:2);
	source = SoundIn.ar(0);
	sig = Greyhole.ar(source, del, damp, size, diff, fb, moddepth, modfreq);
	Out.ar(0, sig*env);
}).add;

a = Synth(\gh, [ \del,  0.04, \damp, 0.1, \size, 0.3, \diff, 0.1, \fb, 0.9, \moddepth, 0.7, \modfreq, 9 ] );
a.set(\gate, 0);

a = Synth(\gh, [ \del, 0.2, \damp, 0.8, \size, 2.3, \diff, 0.1, \fb, 0.9, \moddepth, 0.7, \modfreq, 2.5] );
a.set(\gate, 0);

//RESONANT FILTER
SynthDef(\kl, {
	arg gate=1, rel=0.7, amp=0.5, inamp=0.5;
	var source, sig, env, freqs, ringtimes;
	freqs = Control.names([\freqs]).kr([800, 1071, 1153, 1723]);
	ringtimes = Control.names([\ringtimes]).kr([0.1, 0.1, 0.1, 0.1]);
	env = EnvGen.ar(Env.asr(releaseTime:rel), gate, doneAction:2);
	source = SoundIn.ar(0);
	sig = DynKlank.ar(`[ freqs, nil, ringtimes ], source*inamp);
	Out.ar(0, sig*env*amp);
}).add;


a = Synth(\kl, [\ringtimes,  [0.7, 0.9,0.5, 0.4], \freqs, [100, 150, 160, 180], \inamp, 0.3, \amp, 0.2]);
a.set(\gate, 0);
a = Synth( \kl, [ \ringtimes,  [0.06, 0.04, 0.06, 0.05], \freqs, [800, 883, 1143, 1222], \inamp, 0.14, \amp, 0.5] );
a.set(\gate, 0);
a.set(\ringtimes,  [0.07, 0.08, 0.1, 0.09], \freqs, [800, 883, 1143, 1222], \inamp, 0.27, \amp, 0.5);

//combfilter
SynthDef(\cf, {
	arg gate=1, rel=0.7, decay=1, rlo=0.001, rhi=0.07, rate=0.2, amp=2;
	var source, sig, env, lfodel;
	lfodel = SinOsc.kr(rate).range(rlo, rhi);
	env = EnvGen.ar(Env.asr(releaseTime:rel), gate, doneAction:2);
	source = SoundIn.ar(0);
	sig = CombC.ar(source, delaytime:lfodel, decaytime:decay);
	Out.ar(0, sig*env*amp);
}).add;

a = Synth(\cf, [ \rate, 0.3, \decay, 2.0, \rlo, 0.04, \rhi, 0.055, \amp, 1 ]);
a.set(\gate, 0);
a = Synth(\cf, [ \rate, 13, \decay, 5.0, \rlo, 0.021, \rhi, 0.026, \amp, 1.0 ]);
a.set(\gate, 0);
a.set(\rate, 13, \decay, 5.0, \rlo, 0.021, \rhi, 0.026, \amp, 1.0);

//sample trigger
~s1 = Buffer.read(s,"/Volumes/Ute/DDMI/Samplistic/breakingwindie-2.wav" );

SynthDef(\as, {
	arg gate=1, rel=0.7, buf, startpos=0, rate=1, amp=2, inamp=2, sampamp=2;
	var source, sig, env, samp;
	env = EnvGen.ar(Env.asr(releaseTime:rel), gate, doneAction:2);
	source = SoundIn.ar(0)*inamp;
	samp = PlayBuf.ar(1, buf, rate:rate, startPos:startpos, loop:1);
	sig = (samp*sampamp)*Amplitude.kr(source);
	Out.ar(0, sig*env*amp);
}).add;

a = Synth(\as, [\buf, ~s1]);
a.set(\sampamp, 5, \inamp, 1.0, \amp, 4);
a.set(\gate, 0);

SynthDef(\guitarAmp, {
	arg ibs=0, obs=0, amp=1, atk = 0.01, decay=0, sus=1, rel=0.1, crv = -2, gate=1,amount=0.99;
	var source, dsp, env, amCoef;
	env = EnvGen.ar( Env.adsr(atk, decay, sus, rel, curve:crv), gate );
	source = SoundIn.ar(ibs);
	source = HPF.ar(source, 400)*5;
	//amount = 0.99;
	amCoef= 2*amount/(1-amount);
	dsp = MidEQ.ar(LPF.ar((1+amCoef)*source/(1+(amCoef*source.abs)), [3800, 3900])*0.5, 120, 0.7, 8);
	Out.ar(obs, dsp*amp*env);
}).add;

a = Synth(\guitarAmp);
a.set(\gate, 0);

SynthDef(\ampli, {
	arg gate=1, rel=0.7, amp=1, inamp=2;
	var source, sig, env;
	env = EnvGen.ar(Env.asr(releaseTime:rel), gate, doneAction:2);
	source = SoundIn.ar(0)*inamp;
	sig = source;
	Out.ar(0, sig*env*amp);
}).add;
a = Synth(\ampli);
a.set(\amp, 2);
a.set(\gate, 0);


