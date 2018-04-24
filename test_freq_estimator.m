clear all;

% specify the important parameters
Fs=48000;   % sampling rate in samples per second for all signals
Ts=1/Fs;    % sampling interval

T=2;       % total duration of the signal we want to simulate
tsamp=0:Ts:T;   % vector of sampling times
N_samples=floor(T/Ts);  % total number of samples


% first create a test signal that consists of a complex-sinusoid with
% a randomly chosen frequency
rand_freq=(2*rand-1)*500;   % randomly chosen in the range +/-500 Hz

sinsig=exp(1j*2*pi*rand_freq*tsamp);

str1=sprintf('Actual frequency is: %0.1f Hz', rand_freq);
display(str1)

freq_est=frequency_estimate(sinsig,Ts);

str2=sprintf('Estimated frequency is: %0.1f Hz', freq_est);
display(str2);
