function freq_est = frequency_estimate(sample,Ts)
sigphase=angle((sample).^2);
tsamp_n=Ts:Ts:Ts*length(sample);

uwphase=unwrap(sigphase);

p=polyfit(tsamp_n,uwphase,1); % fit a polynomial of degree 1 i.e. a line

freq_est=p(1)/(2*pi*2);