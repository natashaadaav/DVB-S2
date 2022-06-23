%% Построение зависимостей амплитуды и фазы сигнала на выходе усилителя от амплитуды на входе
% [Отсокритрованные по возрастанию значения амплитуды входного сигнала,
% Индексы, описывающие проведенную сортировку относительно исходного]:
[Xampl,Xindex]=sort(abs(BeforeNA)); 
% Значения амплитуды выходного сигнала:
Yampl=abs(AfterNA);
% Значения фазы выходного сигнала:
Yphase = angle(AfterNA.*conj(BeforeNA));

%% Визуализация зависимостей
figure;
[hAx,hLine1,hLine2] = plotyy(Xampl,Yampl(Xindex),Xampl,Yphase(Xindex));
hLine1.LineStyle = '-';
hLine1.LineWidth = 2;
hLine2.LineStyle = '-';
hLine2.LineWidth = 2;

xlabel('Амплитуда сигнала на входе УМ')
ylabel(hAx(1),'Амплитуда сигнала на выходе УМ') % left y-axis
ylabel(hAx(2),'Смещение фазы сигнала на выходе УМ, рад') % right y-axis
grid on
legend('AM/AM','AM/PM')
