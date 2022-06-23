clc; clear; close all;
%% ��
N_gr = 2;
N_proc = 50+10*fix(N_gr/5); % ������� N_in �� ������������ � ������ ����������� BBFRAME
Fs = 25 * 1e6; % ������� ������������� ������� �� ������ Raiced Cosine Transmit Filter
L = mod(N_gr-1, 5)+7; % ����� ������ ������� 2
% ��������� 32APSK
% ������������� ���������
M = 32;

N_rolloff = mod(N_gr-1, 3)+1; % ����� ������ � ������� 7
roll_off = 0.25; % �� ������� 7

R_LDPC = 4/5; % �������� ���� (LDPC) �� ������� 2
K_BCH = 51648; % �������������� ���� ��� ���� �� ������� 2
N_BCH = 51840; % ������������ ���� ��� ���� �� ������� 2
K_LDPC = 51840; % �������������� ���� LDPC �� ������� 2
t = 12; % �������������� ����������� ��� ���� �� ������� 2
n_LDPC = 64800; % ������������ ���� LDPC ���� �� ������� 2

%% ������� ������������������
BBHEADER = 80;
BBFRAME = K_BCH;
PADDING = BBFRAME * (1-N_proc/100);
DFL = BBFRAME - BBHEADER - PADDING;
N_in = BBHEADER + DFL;

%% ������������ ���������������� ����
FECFRAME = n_LDPC;

%% ���������� ���� ������������� �� ��������� �������� �� ������ �������
SampleRate = 25*1e6;
N_out = 103680;
Dt = 1/(SampleRate*(N_in/N_out)); % ��� �������������

%% ����������
% ���������� �����
Numofrows = 12960;
% ���������� ��������
Numofcols = 5;

%%
% ����������� ������� � �������������� ������������ t = 12:
BCHGeneratorPoly = [1 0 1 0 0 1 1 1 0 0 0 1 0 0 1 1 0 0 0 0 0 1 1 1 0 ...
    1 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 1 0 1 0 0 0 1 0 ...
    0 0 1 1 1 0 0 0 1 0 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0 1 0 1 1 0 0 1 1 ...
    0 1 1 0 0 0 1 1 0 1 1 1 0 0 0 0 1 1 0 1 0 1 0 0 0 0 1 0 0 0 1 0 0 ...
    0 1 0 0 1 0 0 0 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 0 0 0 1 0 1 1 1 1 1 ...
    0 1 1 1 0 1 1 0 0 1 1 0 0 0 0 0 0 0 1 0 0 1 0 1 0 1 0 1 1 1 1 0 0 ...
    1 1 1];
% �������������� ������� ��� ����������� FECFRAME:
BCHPrimitivePoly = [1 0 0 0 0 0 0 0 0 0 0 1 0 1 1 0 1];

% ����������� ����������� �������
H = dvbs2ldpc(R_LDPC);

NMOD = log2(M);
XFECFRAME = n_LDPC/NMOD;

% ��������, ��������� ��������
delay = 10;
%% Memoryless Nonlinearity (���������� ���������)
% ��������� ��������� ���� ���������-��������� (AM/AM)
a_m = 1.9638;
b_m = 0.9945;
AM_AM = [a_m b_m];

% ��������� ��������� ���� ���������-���� (AM/PM)
a_f = 2.5293;
b_f = 2.8168;
AM_PM = [a_f b_f];

% �������� ���������, ��� ������� ����������� ����� ���������
Xnas = 0.9882;
% �������� ����������� ��������� ��� �������� 4.86
Xmax = 3;
% ����������� �������� ��� ������ ������� � ������ ���������
grGain = 4.86*Xnas/Xmax;
% ����������� ����������
varGain = 0.61;

%% �������� � ������������� ����������� �������������
% �������� ������������ ������ �������������
Tphi=1.96;
% ����������� ������������� ��������:
epsOD=0.25;
% �����������:
p = 1e-5;
% ����� �������:
N=(1-p)*(Tphi^2)/(p*epsOD^2);
% ����� �������������:
Tmod = roundn(Dt*N,-1);
% �������� SNR, ��� ������� BER ����������� � ������:
SNR = 10;
% ������ �������� SNR
% SNRrange = [0 3 6 9 12 15 18 21 24 27 30];
%SNRrange = [0 3 6 9 12 13.71 13.73 15 18 21 24 27 30];
SNRrange = [0 2 3 5 6 7 8 9 10 11 12 12.5 13 13.2 13.3 13.4 13.5 13.6 13.71 13.73 15 17 19 21 24 27 30];
%% ���������� ���������
% �������� �������
P_c = 1*grGain;
y1 = 2.72;
y2 = 4.87;
% ������� ����������
R3 = P_c;
% ����� ����������
R1 = R3/y2;
% ������� ����������
R2 = y1 * R1;

apsk32 = [R2*exp(2*pi*1i*1/12+1i*pi/12)...%0
    R2*exp(2*pi*1i*0/12+1i*pi/12)...%1
    R3*exp(2*pi*1i*1/16)...%2
    R3*exp(2*pi*1i*0/16)...%3
    R2*exp(2*pi*1i*4/12+1i*pi/12)...%4
    R2*exp(2*pi*1i*5/12+1i*pi/12)...%5
    R3*exp(2*pi*1i*6/16)...%6
    R3*exp(2*pi*1i*7/16)...%7
    R2*exp(2*pi*1i*10/12+1i*pi/12)...%8
    R2*exp(2*pi*1i*11/12+1i*pi/12)...%9
    R3*exp(2*pi*1i*14/16)...%10
    R3*exp(2*pi*1i*15/16)...%11
    R2*exp(2*pi*1i*7/12+1i*pi/12)...%12
    R2*exp(2*pi*1i*6/12+1i*pi/12)...%13
    R3*exp(2*pi*1i*9/16)...%14
    R3*exp(2*pi*1i*8/16)...%15
    R2*exp(2*pi*1i*2/12+1i*pi/12)...%16
    R1*exp(2*pi*1i*0/4+1i*pi/4)...%17
    R3*exp(2*pi*1i*3/16)...%18
    R3*exp(2*pi*1i*2/16)...%19
    R2*exp(2*pi*1i*3/12+1i*pi/12)...%20
    R1*exp(2*pi*1i*1/4+1i*pi/4)...%21
    R3*exp(2*pi*1i*4/16)...%22
    R3*exp(2*pi*1i*5/16)...%23
    R2*exp(2*pi*1i*9/12+1i*pi/12)...%24
    R1*exp(2*pi*1i*3/4+1i*pi/4)...%25
    R3*exp(2*pi*1i*12/16)...%26
    R3*exp(2*pi*1i*13/16)...%27
    R2*exp(2*pi*1i*8/12+1i*pi/12)...%28
    R1*exp(2*pi*1i*2/4+1i*pi/4)...%29
    R3*exp(2*pi*1i*11/16)...%30
    R3*exp(2*pi*1i*10/16)...%31
    ];

%save initParameters
save('init1','N_in','Dt','K_BCH','N_BCH','K_BCH','BCHGeneratorPoly',...
    'BCHPrimitivePoly','H','Numofcols','Numofrows','NMOD','apsk32',...
    'roll_off','AM_AM','AM_PM','SNR')
%% ������ �������� ������������� ������� �� ��������� � ����:
% ������ ������ ������ step1
%sim('step1.slx')
%pause(0.01);
%display('step1 �����')
% ��������� ������� �������� ��������� �� ����������� ���������:
%[Xampl,Xindex]=sort(abs(BeforeNA));

% �������� ��������� ��������� �������:
%Yampl=abs(AfterNA);
% �������� ���� ��������� �������:
%Yphase = angle(AfterNA.*conj(BeforeNA));

% ������ ��������� ��������� �������:  
%DPDampl0=Xampl./abs(AfterNA(Xindex));
% ������ ��������� ���� �������:
%DPDphase0 = angle(AfterNA(Xindex).*conj(BeforeNA(Xindex)));
% ������� �������� (���������� �������� � �������������� ��������� �������������):
%PolyOrder = 8;
% ������������ ����������������� �������� ��� ���������:
%Poly_ampl = polyfit(Xampl,DPDampl0,PolyOrder);
% ������������ ����������������� �������� ��� ����:
%Poly_phase = polyfit(Xampl,DPDphase0,PolyOrder);
% �������� ������� �� ���������� ���������:
%DPDPolyampl = polyval(Poly_ampl,Xampl);
%DPDPolyphase = polyval(Poly_phase,Xampl);

%save('fromModel1', 'Xampl', 'Yampl', 'Yphase', 'DPDampl0', 'DPDphase0')
%save('init2','Poly_ampl','Poly_phase')

%% ������������ ������������
% display('������� ��')
% figure;
% p=plot(Xampl,DPDampl0,'-b',Xampl,DPDPolyampl,'--r',Xampl,DPDphase0,...
%     '-y',Xampl,DPDPolyphase,'--g');
% p(1).LineWidth=2; p(2).LineWidth=2; p(3).LineWidth=2; p(4).LineWidth=2;
% clear p
% 
% ylabel('������������� ���������, � / ����, ���')
% xlabel('��������� ������� �� �����')
% legend('������ DPDampl','������� DPDPolyampl','������ DPDphase',...
%     '������� DPDPolyphase')
% grid on
%% �������� ������������� � ������
% ������ ������ ������ step2
load init2
display('step2 ��')

% ����������� �������� ��� ��������� BER � EVM:
BER3=zeros(1,length(SNRrange)); % �������� ������������� ����� ����� (SNR)
EVM3=BER3;

i=1;
for SNR=SNRrange
    display(i)
    display(SNR)
    % ������ ������ Simulink
    sim('step2berevm.slx')
    % ����� ��� ������� ������, ���������� � ���������� �������������
    pause(0.2);
    display('step2 �����')
    % ������ BER � EVM (� ����������� EVM)
    BER3(i)=BERawgn2(1);
    EVM3(i)=mean(EVMawgn2(2:end));
    i=i+1;
end
%% ������������ ���������� �����������
% ���������� �������� BER
figure
semilogy(SNRrange,BER3)
grid on
xlabel('SNR,dB')
ylabel('BER')
legend('Nonlinear Amplifier+AWGN with DPD �.�.max')

% ���������� �������� EVM
figure
plot(SNRrange,EVM3)
grid on
xlabel('SNR,dB')
ylabel('EVM,%')
legend('Nonlinear Amplifier+AWGN with DPD �.�.max')

save ('DPDmaxBEREVM','SNRrange','BER3','EVM3')




%[Xampl,Xindex]=sort(abs(BeforeNA));
% �������� ��������� ��������� �������:
% DPDampl=abs(AfterNAdpd);
% �������� ���� ��������� �������:
% DPDphase = angle(AfterNAdpd.*conj(BeforeNAdpd));

% save('fromModel2', 'Xampl', 'Xindex', 'DPDampl', 'DPDphase')
% save('constellations', 'constDPD', 'constnoDPD')
%% ������������ ������������
% display('������� ��')
% figure;
% [~,H1,H2] = plotyy(Xampl,Yampl(Xindex),Xampl,DPDampl(Xindex));
% H2.LineStyle='--';
% H1.LineWidth = 2;
% H2.LineWidth = 2;
% grid on
% xlabel('��������� ������� �� ����� ��')
% ylabel('��������� ������� �� ������ ��')
% legend('AM/AM no DPD','AM/AM DPD')
% clear H1; clear H2
% 
% figure;
% [~,H1,H2] = plotyy(Xampl,Yphase(Xindex),Xampl,DPDphase(Xindex));
% H2.LineStyle='--';
% H1.LineWidth = 2;
% H2.LineWidth = 2;
% grid on
% xlabel('��������� ������� �� ����� ��')
% ylabel('�������� ���� ������� �� ������ ��, ���')
% legend('AM/PM no DPD','AM/PM DPD')
% clear H1; clear H2
% 
% %% ���������� ���������� ���������
% figure;
% plot(real(constnoDPD),imag(constnoDPD),'y.')
% hold on
% grid on
% plot(real(constDPD),imag(constDPD),'b.')
% plot(apsk32,'rx')
% ax = gca;
% ax.GridColor=[1 1 1];
% ax.Color=[0 0 0];
% clear ax
% xlabel('In-phase Amplitude')
% ylabel('Quadrature Amplitude')
% leg = legend('���������� ��������� ������� ��� DPD','���������� ��������� ������� c DPD','����������� ����� (������ apsk32)');
% leg.TextColor = [.65 .65 .65];
% clear leg
%save resultData