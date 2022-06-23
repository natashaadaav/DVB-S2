clc; clear;
load init

% ����������� �������� ��� ��������� BER � EVM:
BER1=zeros(1,length(SNRrange)); % �������� ������������� ����� ����� (SNR)
BER2=BER1;
EVM1=BER1;
EVM2=BER1;

i=1;
for SNR=SNRrange
    display(i)
    display(SNR)
    % ������ ������ Simulink
    sim('myDVBs2.slx');
    % ����� ��� ������� ������, ���������� � ���������� �������������
    pause(0.2);
    % ������ BER � EVM (� ����������� EVM)
    BER1(i)=BERawgn(1);
    BER2(i)=BERna_awgn(1);
    EVM1(i)=mean(EVMawgn(2:end));
    EVM2(i)=mean(EVMna_awgn(2:end));
    i=i+1;
end
%% ������������ ���������� �����������
% ���������� �������� BER
fig1=figure;
semilogy(SNRrange,BER1,SNRrange,BER2)
grid on
xlabel('SNR,dB')
ylabel('BER')
legend('AWGN','Nonlinear Amplifier+ AWGN')
saveas(fig1,'BER','fig')
saveas(fig1,'BER','png')
% ���������� �������� EVM
fig2=figure;
plot(SNRrange,EVM1,SNRrange,EVM2)
grid on
xlabel('SNR,dB')
ylabel('EVM,%')
legend('AWGN','Nonlinear Amplifier+ AWGN')
saveas(fig2,'EVM','fig')
saveas(fig2,'EVM','png')

save simResults
