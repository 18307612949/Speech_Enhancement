
function main
clc;
close all;


%% FIR�o�i��k

% �[�����W
[y,fs,bits]=wavread('test');
% ������W����
n=length(y);
% �W���ܴ�
Y=fft(y);
% ø�s�ϧ�
figure
subplot(2,1,1);plot(y);title('The original signal waveform');grid;
subplot(2,1,2);plot(abs(Y));title('Spectrum of the original signal');grid;
pause(2);
% �����l���W
sound(y);
% �[�J�H�����n
Noise=0.05*randn(n,1);
s=y+Noise;
S=fft(s);
% ø�s�ϧ�
figure
subplot(2,1,1);plot(s);title('signal waveform(After adding noise)');grid;
subplot(2,1,2);plot(abs(S));title('signal spectrum(After adding noise)');grid;
pause(2);
% ����[�����W
sound(s);

% FIR�ﭵ�W�h��
Fp1 = 800;
Fs1 = 1200;
Ft = fs;
wp=2*pi*Fp1/Ft;%�q�a�I���W�v 
ws = 2*pi*Fs1/Ft;%���a�I���W�v
rp = 1;
rs = 50;
p = 1-10.^(-rp/20); %�q�a���a�i��
s1 = 10.^(-rs/20);
fpts = [wp ws];
mag = [1 0];
dev = [p s1];
[n21,wn21,beta,ftype] = kaiserord(fpts,mag,dev);%kaiserord�D���ƺI���W�v
b21 = fir1(n21,wn21,kaiser(n21+1,beta)); %��fir1�]�p�o�i��
c = fftfilt(b21,s);
C=fft(c);
figure
subplot(2,1,1);plot(c);title('signal waveform(After FIR filter noise)');grid;
subplot(2,1,2);plot(abs(C));title('signal spectrum(After FIR filter noise)');grid;
pause(2);
% ����FIR�o�i�᭵�W
sound(c);
% �O�s�[�����W
wavwrite(s,fs,bits,'test+Noise.wav');
% �O�s�h�����W
wavwrite(c,fs,bits,'test+Noise+filter_FIR.wav');


%% IIR�گS�U���o�i 
% �]�mIIR�o�i�Ѽơ]�I���W�v�A���a�W�v�^  Butter�i�Φb�C�q�B���q�B�a�q�M�a���M����IIR�o�i��
fc = 800;
fp = 1200;
Wp = 2*fc/fs;
Ws = 2*fp/fs;
Ap = 1; % �̤p�W�q
As = 30;% �̤j�I��
[N,wn]= buttord(Wp,Ws,Ap,As); % �]�p�o�i�� �䤤n�N���o�i������,
%Wn�N��i�����I���W�v,Wp�MWs���O�O�q�a�M���a���I���W�v
%Rp�MRs���O�O�q�a�M���a���i�����t
[b1,a1] = butter(N,wn); % �ΤگS�o�i���o�i
y_noise_filter = filter(b1,a1,s); % ��IIR�o�i���o�i
C1 = fft(y_noise_filter); % �W���ܴ�
figure
subplot(2,1,1);plot(y_noise_filter);title('signal waveform(After IIR filter noise)');grid;
subplot(2,1,2);plot(abs(C1));title('signal spectrum(After IIR filter noise)');grid;
pause(2);
% ����IIR�o�i�᭵�W
sound(y_noise_filter);
% �O�s�h�����W
wavwrite(y_noise_filter,fs,bits,'test+Noise+filter_IIR.wav');

%% �����o�i
Rz=xcorr(s);
Gz=fft(Rz,n);
Rsz=xcorr(s,y);
Gsz=fft(Rsz,n);
Py = fftn(y);
H=Gsz./Gz; %�����o�i�����ǻ����
S=H.*Py;

ss=real(ifft(S)); %��l�H�������p
ss=ss(1:n);
C2 = fft(ss);
figure
subplot(2,1,1);plot(ss);title('signal waveform(After weina filter noise)');grid;
subplot(2,1,2);plot(abs(C2));title('signal spectrum(After weina filter noise)');grid;
pause(2);
% ����IIR�o�i�᭵�W
sound(ss);
% �O�s�h�����W
wavwrite(y_noise_filter,fs,bits,'test+Noise+filter_weina.wav');


%% �p�i��k�o�i
%�ĥ�ddencmp�����o�H�����q�{�H��
[thr,sorth,keepapp]=ddencmp('den','wv',s);

%ddencmp���G���
thr
sorth
keepapp

% ddencmp����{matlab���H���������Ƥ��@�A�䪺�եή榡���H�U�T�ءG
% 1.[THR,SORH,KEEPAPP,CRIT]=ddencmp(IN1,IN2,X)
% 2.[THR,SORH,KEEPAPP,CRIT]=ddencmp(IN1,'wp',X)
% 3.[THR,SORH,KEEPAPP,CRIT]=ddencmp(IN1,'wv',X)
% ���ddencmp�Ω�����H���b���������Y�L�{�����q�{�H�ȡC
% ��J�Ѽ�X���@���ΤG���H���F
% IN1���Ȭ�'den'��'cmp'�A'den'��ܶi��h���A'cmp'��ܶi�����Y�F
% IN2���Ȭ�'wv'��'wp'�Awv��ܿ�ܤp�i�Awp��ܿ�ܤp�i�]�C
% ��^��THR�O��^���H�ȡFSORH�O�n�H�ȩεw�H�ȿ�ܰѼơF
% KEEPAPP��ܫO�s�C�W�H��.

%%%%%�ĥ�wdencmp��ƶi��H�����H�ȶq�ơ]�Y�H���������^%%
data1=wdencmp('gbl',s,'db5',5,thr,sorth,keepapp);

% ���wdencmp���եή榡���H�U�T�ءG
% (1)[XC,CXC,LXC,PERF0,PERFL2]=wdencmp('gbl',X,'wname',N,THTR,SORH,KEEPAPP);
% (2)[XC,CXC,LXC,PERF0,PERFL2]=wdencmp('lvd',X,'wname',N,THTR,SORH);
% (3)[XC,CXC,LXC,PERF0,PERFL2]=wdencmp('lvd',C,L,'wname',N,THTR,SORH);
% ���wdencmp�Ω�@���ΤG���H�������������Y�C wname�O�ҥΪ��p�i��ơA
% gbl(global���Y�g)��ܨC�@�h���ĥΦP�@���H�ȶi��B�z�A
% lvd��ܨC�h�ĥΤ��P���H�ȶi��B�z�AN��ܤp�i���Ѫ��h�ơA
% THR���H�ȦV�q�A���榡�]2�^�M�]3�^�C�h���n�D���@���H�ȡA�]���H�ȦV�qTHR�����׬�N�A
% SORH��ܿ�ܳn�H�ȩεw�H�ȡ]���O���Ȭ�'s'�M'h'�^�A
% �Ѽ�KEEPAPP���Ȭ�1�ɡA�h�C�W�Y�Ƥ��i���H�ȶq�ơA�Ϥ��A�C�W�Y�ƭn�i���H�ȶq�ơC
% XC�O�n�i����������Y���H���A[CXC,LXC]�OXC���p�i���ѵ��c�APERF0�MPERFL2�O��_�����YL^2���d�Ʀʤ���C

%ø�s�����᪺���H��
C3 = fft(data1); % �W���ܴ�
figure
subplot(2,1,1);plot(data1);title('signal waveform(After xiaobo filter noise)');grid;
subplot(2,1,2);plot(abs(C3));title('signal spectrum(After xiaobo filter noise)');grid;
pause(2);
% ����p�i�o�i�᭵�W
sound(data1);
% �O�s�h�����W
wavwrite(data1,fs,bits,'test+Noise+filter_xiaobo.wav');




