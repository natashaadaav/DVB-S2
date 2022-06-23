clc; clear; close all;
%% ТЗ
N_gr = 2;
N_proc = 50+10*fix(N_gr/5); % процент N_in от используемой в модели размерности BBFRAME
Fs = 25 * 1e6; % Частота дискретизации сигнала на выходе Raiced Cosine Transmit Filter
L = mod(N_gr-1, 5)+7; % Номер строки таблицы 2
% Модуляция 32APSK
% Позиционность модуляции
M = 32;

N_rolloff = mod(N_gr-1, 3)+1; % Номер строки в таблице 7
roll_off = 0.25; % по таблице 7

R_LDPC = 4/5; % Скорость кода (LDPC) по таблице 2
K_BCH = 51648; % Некодированный блок БЧХ кода по таблице 2
N_BCH = 51840; % Кодированный блок БЧХ кода по таблице 2
K_LDPC = 51840; % Некодированный блок LDPC по таблице 2
t = 12; % Корректирующая способность БЧХ кода по таблице 2
n_LDPC = 64800; % Кодированный блок LDPC кода по таблице 2

%% Входная последовательность
BBHEADER = 80;
BBFRAME = K_BCH;
PADDING = BBFRAME * (1-N_proc/100);
DFL = BBFRAME - BBHEADER - PADDING;
N_in = BBHEADER + DFL;

%% Кодированный помехоустойчивый кадр
FECFRAME = n_LDPC;

%% Вычисление шага дискретизации по заданному значению на выходе фильтра
SampleRate = 25*1e6;
N_out = 103680;
Dt = 1/(SampleRate*(N_in/N_out)); % Шаг дискретизации

%% Интерливер
% Количество строк
Numofrows = 12960;
% Количество столбцов
Numofcols = 5;

%%
% Порождающий полином с корректирующей способностью t = 12:
BCHGeneratorPoly = [1 0 1 0 0 1 1 1 0 0 0 1 0 0 1 1 0 0 0 0 0 1 1 1 0 ...
    1 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 1 0 1 0 0 0 1 0 ...
    0 0 1 1 1 0 0 0 1 0 1 0 0 0 0 1 1 0 0 1 1 1 1 0 0 1 0 1 1 0 0 1 1 ...
    0 1 1 0 0 0 1 1 0 1 1 1 0 0 0 0 1 1 0 1 0 1 0 0 0 0 1 0 0 0 1 0 0 ...
    0 1 0 0 1 0 0 0 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 0 0 0 1 0 1 1 1 1 1 ...
    0 1 1 1 0 1 1 0 0 1 1 0 0 0 0 0 0 0 1 0 0 1 0 1 0 1 0 1 1 1 1 0 0 ...
    1 1 1];
% Корректирующий полином для нормального FECFRAME:
BCHPrimitivePoly = [1 0 0 0 0 0 0 0 0 0 0 1 0 1 1 0 1];

% Проверочная разреженная матрица
H = dvbs2ldpc(R_LDPC);

NMOD = log2(M);
XFECFRAME = n_LDPC/NMOD;

% Задержка, вызванная фильтром
delay = 10;
%% Memoryless Nonlinearity (Нелинейные искажения)
% Параметры искажений типа амплитуда-амплитуда (AM/AM)
a_m = 1.9638;
b_m = 0.9945;
AM_AM = [a_m b_m];

% Параметры искажений типа амплитуда-фаза (AM/PM)
a_f = 2.5293;
b_f = 2.8168;
AM_PM = [a_f b_f];

% Значение амплитуды, при котором достигается режим насыщения
Xnas = 0.9882;
% Значение максмальной амплитуды при усилении 4.86
Xmax = 3;
% Коэффициент усиления для работы близкой к режиму насыщения
grGain = 4.86*Xnas/Xmax;
% Нормирующий коэффицент
varGain = 0.61;

%% Точность и достоверность результатов моделирования
% Квантиль гауссовского закона распределения
Tphi=1.96;
% Достаточная относительная точность:
epsOD=0.25;
% Вероятность:
p = 1e-5;
% Объем выборки:
N=(1-p)*(Tphi^2)/(p*epsOD^2);
% Время моделирования:
Tmod = roundn(Dt*N,-1);
% Значение SNR, при котором BER вырождается в прямую:
SNR = 10;
% Вектор значений SNR
% SNRrange = [0 3 6 9 12 15 18 21 24 27 30];
%SNRrange = [0 3 6 9 12 13.71 13.73 15 18 21 24 27 30];
SNRrange = [0 2 3 5 6 7 8 9 10 11 12 12.5 13 13.2 13.3 13.4 13.5 13.6 13.71 13.73 15 17 19 21 24 27 30];
%% Сигнальное созвездие
% Мощность сигнала
P_c = 1*grGain;
y1 = 2.72;
y2 = 4.87;
% Большая окружность
R3 = P_c;
% Малая окружность
R1 = R3/y2;
% Средняя окружность
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
%% Оценка векторов предыскажений сигнала по амплитуде и фазе:
% Запуск первой модели step1
%sim('step1.slx')
%pause(0.01);
%display('step1 готов')
% Получение вектора значений амплитуды до нелинейного усилителя:
%[Xampl,Xindex]=sort(abs(BeforeNA));

% Значения амплитуды выходного сигнала:
%Yampl=abs(AfterNA);
% Значения фазы выходного сигнала:
%Yphase = angle(AfterNA.*conj(BeforeNA));

% Оценка искажений амплитуды сигнала:  
%DPDampl0=Xampl./abs(AfterNA(Xindex));
% Оценка искажений фазы сигнала:
%DPDphase0 = angle(AfterNA(Xindex).*conj(BeforeNA(Xindex)));
% Порядок полинома (определяет точность и вычислительную сложность аппроксимации):
%PolyOrder = 8;
% Коэффициенты аппроксимирующего полинома для амплитуды:
%Poly_ampl = polyfit(Xampl,DPDampl0,PolyOrder);
% Коэффициенты аппроксимирующего полинома для фазы:
%Poly_phase = polyfit(Xampl,DPDphase0,PolyOrder);
% Значения функций по полученным полиномам:
%DPDPolyampl = polyval(Poly_ampl,Xampl);
%DPDPolyphase = polyval(Poly_phase,Xampl);

%save('fromModel1', 'Xampl', 'Yampl', 'Yphase', 'DPDampl0', 'DPDphase0')
%save('init2','Poly_ampl','Poly_phase')

%% Визуализация зависимостей
% display('Графики го')
% figure;
% p=plot(Xampl,DPDampl0,'-b',Xampl,DPDPolyampl,'--r',Xampl,DPDphase0,...
%     '-y',Xampl,DPDPolyphase,'--g');
% p(1).LineWidth=2; p(2).LineWidth=2; p(3).LineWidth=2; p(4).LineWidth=2;
% clear p
% 
% ylabel('Предискажения амплитуды, В / фазы, рад')
% xlabel('Амплитуда сигнала на входе')
% legend('Оценка DPDampl','Полином DPDPolyampl','Оценка DPDphase',...
%     'Полином DPDPolyphase')
% grid on
%% Внесение предискажений в модель
% Запуск второй модели step2
load init2
display('step2 го')

% Определение векторов для измерения BER и EVM:
BER3=zeros(1,length(SNRrange)); % Диапазон соответствует числу точек (SNR)
EVM3=BER3;

i=1;
for SNR=SNRrange
    display(i)
    display(SNR)
    % Запуск модели Simulink
    sim('step2berevm.slx')
    % Пауза для импорта данных, полученных в результате моделирования
    pause(0.2);
    display('step2 готов')
    % Запись BER и EVM (с усреднением EVM)
    BER3(i)=BERawgn2(1);
    EVM3(i)=mean(EVMawgn2(2:end));
    i=i+1;
end
%% Визуализация полученных результатов
% Построение графиков BER
figure
semilogy(SNRrange,BER3)
grid on
xlabel('SNR,dB')
ylabel('BER')
legend('Nonlinear Amplifier+AWGN with DPD р.т.max')

% Построение графиков EVM
figure
plot(SNRrange,EVM3)
grid on
xlabel('SNR,dB')
ylabel('EVM,%')
legend('Nonlinear Amplifier+AWGN with DPD р.т.max')

save ('DPDmaxBEREVM','SNRrange','BER3','EVM3')




%[Xampl,Xindex]=sort(abs(BeforeNA));
% Значения амплитуды выходного сигнала:
% DPDampl=abs(AfterNAdpd);
% Значения фазы выходного сигнала:
% DPDphase = angle(AfterNAdpd.*conj(BeforeNAdpd));

% save('fromModel2', 'Xampl', 'Xindex', 'DPDampl', 'DPDphase')
% save('constellations', 'constDPD', 'constnoDPD')
%% Визуализация зависимостей
% display('Графики го')
% figure;
% [~,H1,H2] = plotyy(Xampl,Yampl(Xindex),Xampl,DPDampl(Xindex));
% H2.LineStyle='--';
% H1.LineWidth = 2;
% H2.LineWidth = 2;
% grid on
% xlabel('Амплитуда сигнала на входе УМ')
% ylabel('Амплитуда сигнала на выходе УМ')
% legend('AM/AM no DPD','AM/AM DPD')
% clear H1; clear H2
% 
% figure;
% [~,H1,H2] = plotyy(Xampl,Yphase(Xindex),Xampl,DPDphase(Xindex));
% H2.LineStyle='--';
% H1.LineWidth = 2;
% H2.LineWidth = 2;
% grid on
% xlabel('Амплитуда сигнала на входе УМ')
% ylabel('Смещение фазы сигнала на выходе УМ, рад')
% legend('AM/PM no DPD','AM/PM DPD')
% clear H1; clear H2
% 
% %% Построение сигнальных созвездий
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
% leg = legend('Сигнальное созвездие сигнала без DPD','Сигнальное созвездие сигнала c DPD','Референсные точки (вектор apsk32)');
% leg.TextColor = [.65 .65 .65];
% clear leg
%save resultData