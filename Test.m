n=0.9;
load('init.mat', 'apsk32','Tmod','SNRrange3','SNRrange4')
apsk32 = apsk32*n;
SNRrange3 = [0 2 4 6 8 10 12 12.5 12.8 13 13.2 13.4 13.5 13.6 13.7 13.73 16 18 20 22 24 26 28 30];
SNRrange4 = [0 2 4 6 8 10 12 13 13.2 13.4 13.6 13.63 16 18 20 24 26 28 30];
set_param('step2/QAMDemod','SigCon',mat2str(apsk32))
set_param('step2/QAMMod','SigCon',mat2str(apsk32))
if n==1
    load init2
else
    load init2cor
end
Ps = 0.2562;
%%Учтем изменения в мощности:
set_param('step2','StopTime', num2str(0.1)) 
set_param('step2/AWGN','Ps',num2str(Ps))
sim('step2.slx')
display(mean(RMS))
pause(0.2);
Ps = mean(RMS);
% Запуск модели Simulink step 2 (при SNR, объявленном ранее)
set_param('step2','StopTime', num2str(Tmod)) 
set_param('step2/AWGN','Ps',num2str(Ps))
sim('step2.slx')
% Пауза для импорта данных, полученных в результате моделирования
pause(0.3);

if n==1
    SNRrange=SNRrange3;
else
    SNRrange=SNRrange4;
end

% Получение вектора значений амплитуды до нелинейного усилителя:
[Xampl_1,Xindex_1] = sort(abs(BeforeNAdpd));
% Значения амплитуды выходного сигнала:
DPDampl_1 = abs(AfterNAdpd);
% Значения фазы выходного сигнала:
DPDphase_1 = angle(AfterNAdpd.*conj(BeforeNAdpd));

% Определение векторов для измерения BER и EVM:
BER3 = zeros(1,length(SNRrange)); % Диапазон соответствует числу точек (SNR)
BER4 = BER3;
EVM3 = BER3;
EVM4 = BER3;

i=1;
for SNR=SNRrange
    set_param('step2/AWGN','SNRdB',num2str(SNR))
    display(i)
    display(SNR)
    % Запуск модели Simulink
    sim('step2.slx')
    % Пауза для импорта данных, полученных в результате моделирования
    pause(0.2);
    % Запись BER и EVM (с усреднением EVM)
    if n==1
        BER3(i) = BERawgn(length(BERawgn));
        EVM3(i) = mean(EVMawgn(:,1));
    else
        BER4(i) = BERawgn(length(BERawgn));
        EVM4(i) = mean(EVMawgn(:,1));
    end
    display(mean(MER))
    display(BERawgn(length(BERawgn)))
    if BERawgn(length(BERawgn))==0
        break
    end
    i=i+1;
end

% Сохранение данных:
if n==1
    save('constellations1', 'constDPD', 'constnoDPD')
    save('AMAM_AMPM_DPD_1', 'Xampl_1', 'Xindex_1', 'DPDampl_1', 'DPDphase_1')
    save ('BER_EVM_3', 'BER3', 'EVM3', 'SNRrange3')
else 
    save('constellations2', 'constDPD', 'constnoDPD')
    save('AMAM_AMPM_DPD_2', 'Xampl_1', 'Xindex_1', 'DPDampl_1', 'DPDphase_1')
    save ('BER_EVM_4', 'BER4', 'EVM4', 'SNRrange4')
end
if n==1
    BER = BER3;
else
    BER = BER4;
end
figure
semilogy(SNRrange,BER)
grid on
xlabel('SNR,dB')
ylabel('BER')
title('BER_EVM_Text')