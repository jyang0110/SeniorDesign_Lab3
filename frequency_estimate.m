function freq_est = frequency_estimate(sample,Ts)
sigphase=angle((sample).^2); % phase of the squared signal
tsamp_n=Ts:Ts:Ts*length(sample); % time values for the sample

uwphase=unwrap(sigphase); % unwrap the phase so the slope can be calculated

p=polyfit(tsamp_n,uwphase,1); % fit a polynomial of degree 1 i.e. a line

freq_est=p(1)/(2*pi*2); % the frequency error is one half the slope of the phase
