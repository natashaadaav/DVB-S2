function [n] = graphfunc(n)
% Визуализация полученных зависимостей.
% Входной параметр - процент от уровня сигнала в режиме насыщения, при n=2
% происходит построение совмещенных графиков.
load('init.mat', 'apsk32')

if n==1
    % Сигнальные созвездия:
    load constellations1
    constText='Сигнальное созвездие для случая с рабочей точкой, близкой к режиму насыщения';
    % Построение графиков векторов предыскажений сигнала по амплитуде и фазе
    load DPD_vec
    DPDvecText='DPD без коррекции';
    % Построение характеристик AM/AM и AM/PM c DPD
    load AMAM_AMPM_DPD_1
    AMAM_AMPM_Text1 = 'Характеристики AM/AM при рабочей точке, близкой к режиму насыщения';
    AMAM_AMPM_Text2 = 'Характеристики AM/PM при рабочей точке, близкой к режиму насыщения';
    % Построение BER
    load BER_EVM_3
    BER = BER3;
    EVM = EVM3;
    SNRrange = SNRrange3;
    BER_EVM_Text='Nonlinear Amplifier + AWGN в рабочей точкой, близкой к режиму насыщения';
    
elseif n==2
    %% Построение характеристик AM/AM и AM/PM
    load('DPD_vec.mat', 'Xampl_0', 'Yampl_0', 'Xindex_0', 'Yphase_0')
    figure
    [ax1,Line1,Line2] = plotyy(Xampl_0,Yampl_0(Xindex_0),Xampl_0,Yphase_0(Xindex_0));
    Line1.LineStyle = '-';
    Line1.LineWidth = 2;
    Line2.LineStyle = '-';
    Line2.LineWidth = 2;
    clear Line1; clear Line2
    title('Характеристики без системы DPD')
    xlabel('Амплитуда сигнала на входе УМ')
    ylabel(ax1(1),'Амплитуда сигнала на выходе УМ') % left y-axis
    ylabel(ax1(2),'Смещение фазы сигнала на выходе УМ, рад') % right y-axis
    grid on
    legend('AM/AM','AM/PM')
    clear ax1
    
    %% Построение BER
    load BER_EVM_1_2
    load BER_EVM_3
    load BER_EVM_4
    
    figure
    semilogy(SNRrange1_2,BER1,SNRrange1_2,BER2,SNRrange3,BER3,SNRrange4,BER4)
    grid on
    xlabel('SNR,dB')
    ylabel('BER')
    legend('AWGN','Nonlinear Amplifier+ AWGN',...
        'Nonlinear Amplifier+AWGN с DPD на режиме насыщения',...
        'Nonlinear Amplifier+AWGN с DPD со смещенной рабочей точкой')
    
    figure
    plot(SNRrange1_2,EVM1,SNRrange1_2,EVM2,SNRrange3,EVM3,SNRrange4,EVM4)
    grid on
    xlabel('SNR,dB')
    ylabel('EVM,%')
    legend('AWGN','Nonlinear Amplifier+ AWGN',...
        'Nonlinear Amplifier+AWGN с DPD на режиме насыщения',...
        'Nonlinear Amplifier+AWGN с DPD со смещенной рабочей точкой')
    
    
else
    % Сигнальные созвездия:
    load constellations2
    apsk32 = apsk32*n;
    constText='Сигнальное созвездие для случая со смещением рабочей точки';
    % Построение графиков векторов предыскажений сигнала по амплитуде и фазе
    load DPD_vec_cor
    DPDvecText='DPD с коррекцией';
    % Построение характеристик AM/AM и AM/PM c DPD
    load AMAM_AMPM_DPD_2
    AMAM_AMPM_Text1 = 'Характеристики AM/AM при смещении рабочей точки';
    AMAM_AMPM_Text2 = 'Характеристики AM/PM при смещении рабочей точки';
    % Построение BER
    load BER_EVM_4
    BER = BER4;
    EVM = EVM4;
    SNRrange = SNRrange4;
    BER_EVM_Text='Nonlinear Amplifier + AWGN со смещением рабочей точки';
end

if n~=2
    %% Построение сигнального созвездия
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
    leg = legend('Сигнальное созвездие сигнала без DPD',...
        'Сигнальное созвездие сигнала c DPD',...
        'Референсные точки (вектор apsk32)');
    leg.TextColor = [.65 .65 .65];
    clear leg
    
    %% Построение графиков векторов предыскажений сигнала по амплитуде и фазе
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
    ylabel('Предискажения амплитуды, В / фазы, рад')
    xlabel('Амплитуда сигнала на входе')
    legend('Оценка DPDampl_0','Полином DPDPolyampl','Оценка DPDphase_0',...
        'Полином DPDPolyphase')
    grid on
    
    %% Построение характеристик AM/AM и AM/PM c DPD
    figure
    [~,Line3,Line4] = plotyy(Xampl_0,Yampl_0(Xindex_0), Xampl_1,DPDampl_1(Xindex_1));
    Line3.LineWidth = 2;
    Line4.LineWidth = 2;
    clear Line3; clear Line4
    grid on
    title(AMAM_AMPM_Text1)
    xlabel('Амплитуда сигнала на входе УМ')
    ylabel('Амплитуда сигнала на выходе УМ')
    legend('AM/AM без DPD','AM/AM с DPD')
    
    figure
    [ax2,Line5,Line6] = plotyy(Xampl_0,Yphase_0(Xindex_0), Xampl_1,DPDphase_1(Xindex_1));
    Line5.LineWidth = 2;
    Line6.LineWidth = 2;
    clear Line5; clear Line6
    grid on
    title(AMAM_AMPM_Text2)
    ylabel(ax2(1),'Амплитуда сигнала на выходе УМ') % left y-axis
    ylabel(ax2(2),'Смещение фазы сигнала на выходе УМ, рад') % right y-axis
    xlabel('Амплитуда сигнала на входе УМ')
    legend('AM/PM без DPD','AM/PM с DPD')
    
    %% Построение BER
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