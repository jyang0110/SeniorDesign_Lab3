close all;
clear all;

Iwavfilename='distorted_I.wav';
Qwavfilename='distorted_Q.wav';

[Isamples,Fs]=audioread(Iwavfilename);
[Qsamples,Fs]=audioread(Qwavfilename);
Ts=1/Fs;    % sampling interval
signal=Isamples'+1j*Qsamples';

T_buf=1;  % number of seconds worth of samples
N_buf=floor(T_buf/Ts);

n=0;
error_sum=0;
undistorted = nan(1,length(signal));
while ((n+1)*N_buf <= length(signal))
    nrange=(n*N_buf+1:(n+1)*N_buf);
    freq_est=frequency_estimate(signal(nrange),Ts);
    error_sum=error_sum+freq_est;
    str2=sprintf('Estimated frequency is: %0.1f Hz', freq_est);
    display(str2);
    
    frequencyerror=exp(-1j*2*pi*freq_est*(nrange)*Ts);
    undistorted(nrange) = signal(nrange).*frequencyerror;
    n=n+1;
end;

average_error = error_sum/(n-1);
display(sprintf('Average frequency is: %0.1f Hz', average_error))
undistorted = real(undistorted)/max(abs(real(undistorted)));

audiowrite('undistorted.wav',undistorted,Fs);
