close all;
clear all;

I_channel='distorted_I.wav';
Q_channel='distorted_Q.wav';
wavchunksizefix(I_channel);
wavchunksizefix(Q_channel);

[II,Fs]=audioread(I_channel); %Load the I channel distorted signal into the matlab
[QQ,Fs]=audioread(Q_channel); %Load the Q channel distorted signal into the matlab

Ts=1/Fs;

signal=II'+1j*QQ';
N = length(signal)

T_buf = 0.5;  % number of seconds worth of samples
N_buf = floor(T_buf/Ts);

n=0;
error_sum=0;
undistorted = nan(1,N);

% now sit in a loop and process blocks of samples until we run out
while ((n+1)*N_buf <= N)
    nrange=(n*N_buf+1:(n+1)*N_buf);
    freq_est=estimate(signal(nrange),Ts);
    error_sum=error_sum+freq_est;
    str2=sprintf('Estimated frequency is: %0.1f Hz', freq_est);
    display(str2);
    
    frequencyerror=exp(-1j*2*pi*freq_est*(nrange)*Ts);
    undistorted(nrange) = signal(nrange).*frequencyerror;
    n=n+1;
end;

average_error = error_sum/(n-1);
str1 = sprintf('Average frequency is: %0.1f Hz', average_error));
display(str1);
undistorted = real(undistorted)/max(abs(real(undistorted)));

audiowrite('undistorted.wav',undistorted,Fs);
