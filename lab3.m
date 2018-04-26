close all; %deletes all figures
clear all; %removes all variables from the current workspace

I_channel='distorted_I.wav';
Q_channel='distorted_Q.wav';
wavchunksizefix(I_channel);
wavchunksizefix(Q_channel);
[II,Fs]=audioread(I_channel); %Read I channel signal, Fs = sampling rate in I channel singal per second
[QQ,Fs]=audioread(Q_channel); %Read Q channel signal, Fs = sampling rate in Q channel singal per second

Ts=1/Fs; % sampling interval

signal=II'+j*QQ'; % s = i + jq, to combine real and imaginary part
N = length(signal) % length of the signal
singal = sigwin.hann(N,'periodic'); % Using hanning window to reduce leakage and frequency interference

T_buf = 0.5;  % number of seconds worth of samples
N_buf = floor(T_buf/Ts);

n=0;
p=0;
undistorted = zeros(1,N);
ffreq_estimate = 0;

% now sit in a loop and process blocks of samples until we run out
while ((n+1)*N_buf <= N)
    freq_estimate=freq_estimator(signal((n*N_buf+1:(n+1)*N_buf)),Ts);
    p=p+freq_estimate;
    frequencyerror=exp(-j*2*pi*freq_estimate*((n*N_buf+1:(n+1)*N_buf))*Ts);
    undistorted((n*N_buf+1:(n+1)*N_buf)) = signal((n*N_buf+1:(n+1)*N_buf)).*frequencyerror;
    ffreq_estimate = ffreq_estimate + freq_estimate;
    n=n+1;
end;

freq_avg_estimate = ffreq_estimate/(n-1);
str3=sprintf('Average estimated frequency is: %0.1f Hz', freq_avg_estimate);
display(str3);

aveg_freq = p/(n-1);

str1=sprintf('Actual frequency is: %0.1f Hz', aveg_freq);
display(str1)

undistorted = real(undistorted)/max(abs(real(undistorted)));
audiowrite('undistorted.wav',undistorted,Fs);
function freq_estimate = freq_estimator(audio,Ts)
sigphase=angle((audio).^2); % phase of the squared signal
tsamp_n=Ts:Ts:Ts*length(audio); % time values for the sample

uwphase=unwrap(sigphase); % unwrap the phase so the slope can be calculated

p=polyfit(tsamp_n,uwphase,1); % fit a polynomial of degree 1 i.e. a line

freq_estimate=p(1)/(2*pi*2); % the frequency error is one half the slope of the phase

str2=sprintf('Estimated frequency is: %0.1f Hz', freq_estimate);

display(str2);
end
