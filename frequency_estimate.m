function freq_estimator = estimate(audio,Ts)
sigphase=angle((audio).^2);
tsamp_n=Ts:Ts:Ts*length(audio);

uwphase=unwrap(sigphase);

p=polyfit(tsamp_n,uwphase,1); % fit a polynomial of degree 1 i.e. a line

freq_est=p(1)/(2*pi*2);
