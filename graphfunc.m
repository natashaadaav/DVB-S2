function [n] = graphfunc(n)
% ������������ ���������� ������������.
% ������� �������� - ������� �� ������ ������� � ������ ���������, ��� n=2
% ���������� ���������� ����������� ��������.
load('init.mat', 'apsk32')

if n==1
    % ���������� ���������:
    load constellations1
    constText='���������� ��������� ��� ������ � ������� ������, ������� � ������ ���������';
    % ���������� �������� �������� ������������� ������� �� ��������� � ����
    load DPD_vec
    DPDvecText='DPD ��� ���������';
    % ���������� ������������� AM/AM � AM/PM c DPD
    load AMAM_AMPM_DPD_1
    AMAM_AMPM_Text1 = '�������������� AM/AM ��� ������� �����, ������� � ������ ���������';
    AMAM_AMPM_Text2 = '�������������� AM/PM ��� ������� �����, ������� � ������ ���������';
    % ���������� BER
    load BER_EVM_3
    BER = BER3;
    EVM = EVM3;
    SNRrange = SNRrange3;
    BER_EVM_Text='Nonlinear Amplifier + AWGN � ������� ������, ������� � ������ ���������';
    
elseif n==2
    %% ���������� ������������� AM/AM � AM/PM
    load('DPD_vec.mat', 'Xampl_0', 'Yampl_0', 'Xindex_0', 'Yphase_0')
    figure
    [ax1,Line1,Line2] = plotyy(Xampl_0,Yampl_0(Xindex_0),Xampl_0,Yphase_0(Xindex_0));
    Line1.LineStyle = '-';
    Line1.LineWidth = 2;
    Line2.LineStyle = '-';
    Line2.LineWidth = 2;
    clear Line1; clear Line2
    title('�������������� ��� ������� DPD')
    xlabel('��������� ������� �� ����� ��')
    ylabel(ax1(1),'��������� ������� �� ������ ��') % left y-axis
    ylabel(ax1(2),'�������� ���� ������� �� ������ ��, ���') % right y-axis
    grid on
    legend('AM/AM','AM/PM')
    clear ax1
    
    %% ���������� BER
    load BER_EVM_1_2
    load BER_EVM_3
    load BER_EVM_4
    
    figure
    semilogy(SNRrange1_2,BER1,SNRrange1_2,BER2,SNRrange3,BER3,SNRrange4,BER4)
    grid on
    xlabel('SNR,dB')
    ylabel('BER')
    legend('AWGN','Nonlinear Amplifier+ AWGN',...
        'Nonlinear Amplifier+AWGN � DPD �� ������ ���������',...
        'Nonlinear Amplifier+AWGN � DPD �� ��������� ������� ������')
    
    figure
    plot(SNRrange1_2,EVM1,SNRrange1_2,EVM2,SNRrange3,EVM3,SNRrange4,EVM4)
    grid on
    xlabel('SNR,dB')
    ylabel('EVM,%')
    legend('AWGN','Nonlinear Amplifier+ AWGN',...
        'Nonlinear Amplifier+AWGN � DPD �� ������ ���������',...
        'Nonlinear Amplifier+AWGN � DPD �� ��������� ������� ������')
    
    
else
    % ���������� ���������:
    load constellations2
    apsk32 = apsk32*n;
    constText='���������� ��������� ��� ������ �� ��������� ������� �����';
    % ���������� �������� �������� ������������� ������� �� ��������� � ����
    load DPD_vec_cor
    DPDvecText='DPD � ����������';
    % ���������� ������������� AM/AM � AM/PM c DPD
    load AMAM_AMPM_DPD_2
    AMAM_AMPM_Text1 = '�������������� AM/AM ��� �������� ������� �����';
    AMAM_AMPM_Text2 = '�������������� AM/PM ��� �������� ������� �����';
    % ���������� BER
    load BER_EVM_4
    BER = BER4;
    EVM = EVM4;
    SNRrange = SNRrange4;
    BER_EVM_Text='Nonlinear Amplifier + AWGN �� ��������� ������� �����';
end

if n~=2
    %% ���������� ����������� ���������
    figure
    plot(real(constnoDPD),imag(constnoDPD),'r.')
    hold on
    grid on
    plot(real(constDPD),imag(constDPD),'b.')
    plot(apsk32,'gx')
    ax = gca;
    ax.Color=[1 1 1];
    clear ax
    xlabel('In-phase Amplitude')
    ylabel('Quadrature Amplitude')
    title(constText)
    leg = legend('���������� ��������� ������� ��� DPD',...
        '���������� ��������� ������� c DPD',...
        '����������� ����� (������ apsk32)');
    leg.TextColor = [.65 .65 .65];
    clear leg
    
    %% ���������� �������� �������� ������������� ������� �� ��������� � ����
    figure
    p1 = plot(Xampl_0,DPDampl_0, Xampl_0,DPDPolyampl, Xampl_0,DPDphase_0,...
        Xampl_0,DPDPolyphase);
    p1(1).LineWidth = 2;
    p1(2).LineStyle = '--';
    p1(2).LineWidth = 2;
    p1(3).LineWidth = 2;
    p1(4).LineStyle = '--';
    p1(4).LineWidth = 2;
    clear p1
    title(DPDvecText)
    ylabel('������������� ���������, � / ����, ���')
    xlabel('��������� ������� �� �����')
    legend('������ DPDampl_0','������� DPDPolyampl','������ DPDphase_0',...
        '������� DPDPolyphase')
    grid on
    
    %% ���������� ������������� AM/AM � AM/PM c DPD
    figure
    [~,Line3,Line4] = plotyy(Xampl_0,Yampl_0(Xindex_0), Xampl_1,DPDampl_1(Xindex_1));
    Line3.LineWidth = 2;
    Line4.LineWidth = 2;
    clear Line3; clear Line4
    grid on
    title(AMAM_AMPM_Text1)
    xlabel('��������� ������� �� ����� ��')
    ylabel('��������� ������� �� ������ ��')
    legend('AM/AM ��� DPD','AM/AM � DPD')
    
    figure
    [ax2,Line5,Line6] = plotyy(Xampl_0,Yphase_0(Xindex_0), Xampl_1,DPDphase_1(Xindex_1));
    Line5.LineWidth = 2;
    Line6.LineWidth = 2;
    clear Line5; clear Line6
    grid on
    title(AMAM_AMPM_Text2)
    ylabel(ax2(1),'��������� ������� �� ������ ��') % left y-axis
    ylabel(ax2(2),'�������� ���� ������� �� ������ ��, ���') % right y-axis
    xlabel('��������� ������� �� ����� ��')
    legend('AM/PM ��� DPD','AM/PM � DPD')
    
    %% ���������� BER
    figure
    semilogy(SNRrange,BER)
    grid on
    xlabel('SNR,dB')
    ylabel('BER')
    title(BER_EVM_Text)
    
    figure
    plot(SNRrange, EVM)
    grid on
    xlabel('SNR,dB')
    ylabel('EVM,%')
    title(BER_EVM_Text)
    
end
end