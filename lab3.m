close all;
clear all;

I_channel='distorted_I.wav';
Q_channel='distorted_Q.wav';
wavchunksizefix(I_channel);
wavchunksizefix(Q_channel);
[II,Fs]=audioread(I_channel); %Read I channel signal, Fs = sampling rate in samples per second for I channel singal
[QQ,Fs]=audioread(Q_channel); %Read Q channel signal, Fs = sampling rate in samples per second for Q channel singal

Ts=1/Fs; % sampling interval

signal=II'+j*QQ'; % s = i + jq
N = length(signal) % length of the signal
singal = sigwin.hann(N,'periodic'); % Using hanning window

T_buf = 0.5;  % number of seconds worth of samples
N_buf = floor(T_buf/Ts);

n=0;
p=0;
undistorted = zeros(1,N);

% now sit in a loop and process blocks of samples until we run out
while ((n+1)*N_buf <= N)
    nrange=(n*N_buf+1:(n+1)*N_buf);
    freq_estimate=freq_estimator(signal(nrange),Ts);
    p=p+freq_estimate;
    
    frequencyerror=exp(-1j*2*pi*freq_estimate*(nrange)*Ts);
    undistorted(nrange) = signal(nrange).*frequencyerror;
    
    n=n+1;
end;

average_error = p/(n-1);

str1=sprintf('Actual frequency is: %0.1f Hz', average_error);
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
