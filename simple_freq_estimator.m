% a simple script that estimates the frequency of a complex-sinusoidal
% signal mixed with noise

clear all;

% specify the important parameters
Fs=48000;   % sampling rate in samples per second for all signals
Ts=1/Fs;    % sampling interval

SNR_db=5;      % 7 dB is a low SNR, so this simulates a fairly noisy system
noisepower=1;   % without loss of generality, we can fix the noise power to unity
sigpower=10^(SNR_db/10)*noisepower;

T=2;       % total duration of the signal we want to simulate
tsamp=0:Ts:T;   % vector of sampling times
N_samples=floor(T/Ts);  % total number of samples


% first create a test signal that consists of a complex-sinusoid with
% a randomly chosen frequency, mixed with noise
rand_freq=(2*rand-1)*500;   % randomly chosen in the range +/-500 Hz

% complex-valued white Gaussian noise - the usual way to model noise
% average noise power in each sample is unity
noisesig=sqrt(noisepower)/sqrt(2)*(randn(size(tsamp))+1j*randn(size(tsamp)));
sinsig=sqrt(sigpower)*exp(1j*2*pi*rand_freq*tsamp);

sinsig_with_noise=sinsig+noisesig;



% we now have a test signal that consists of a complex-sinusoid mixed with
% noise. Let's now write some simple code that can estimate the frequency
% of the sinusoid. This algorithm is based on the simple observation that
% the phase of a complex-sinusoid increases linearly over time and the
% slope is proportional to the frequency. So we just fit a line to the
% phase and use the slope of the line-fit to estimate frequency

% but first we need to choose a buffer size i.e. how many samples are we
% going to use to produce a single estimate. There is a tradeoff between
% latency and accuracy in choosing this parameter
T_buf=0.5;  % number of seconds worth of samples
N_buf=floor(T_buf/Ts);

% now sit in a loop and process blocks of samples until we run out
n=0;
while ((n+1)*N_buf <= N_samples)
    
    sigphase=angle(sinsig_with_noise(n*N_buf+1:(n+1)*N_buf));
    tsamp_n=tsamp(n*N_buf+1:(n+1)*N_buf);
    
    % it is important to "unwrap" the phase because otherwise, everytime the
    % phase crosses 360 deg, it is reset back to zero which will make it
    % impossible to see the linear variation over time.
    uwphase=unwrap(sigphase);
    p=polyfit(tsamp_n,uwphase,1); % fit a polynomial of degree 1 i.e. a line
    
    freq_est=p(1)/(2*pi);
    str2=sprintf('Estimated frequency is: %0.1f Hz', freq_est);
    display(str2);
    n=n+1;
end;


% compare the actual frequency with the estimates
str1=sprintf('Actual frequency is: %0.1f Hz', rand_freq);
display(str1)

