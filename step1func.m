function [Poly_ampl,Poly_phase] = step1func( n )
% Оценка векторов предыскажений сигнала по амплитуде и фазе
% Входной параметр - процент от уровня сигнала в режиме насыщения
load('init.mat', 'apsk32','Tmod')
apsk32 = apsk32*n;
set_param('step1','StopTime', num2str(Tmod))
set_param('step1/QAMMod','SigCon',mat2str(apsk32))
sim('step1.slx')
pause(0.1)
% Получение вектора значений амплитуды до нелинейного усилителя:
[Xampl_0,Xindex_0] = sort(abs(BeforeNA));

% Значения амплитуды выходного сигнала:
Yampl_0 = abs(AfterNA);
% Значения фазы выходного сигнала:
Yphase_0 = angle(AfterNA.*conj(BeforeNA));
% Оценка искажений амплитуды сигнала:
DPDampl_0 = Xampl_0./abs(AfterNA(Xindex_0));
% Оценка искажений фазы сигнала:
DPDphase_0 = angle(AfterNA(Xindex_0).*conj(BeforeNA(Xindex_0)));
% Порядок полинома (определяет точность и вычислительную сложность аппроксимации):
PolyOrder = 8;
% Коэффициенты аппроксимирующего полинома для амплитуды:
Poly_ampl = polyfit(Xampl_0,DPDampl_0,PolyOrder);
% Коэффициенты аппроксимирующего полинома для фазы:
Poly_phase = polyfit(Xampl_0,DPDphase_0,PolyOrder);
% Значения функций по полученным полиномам:
DPDPolyampl = polyval(Poly_ampl,Xampl_0);
DPDPolyphase = polyval(Poly_phase,Xampl_0);

if n==1
    save('step1result','BeforeNA','AfterNA')
    save('DPD_vec', 'Xampl_0', 'Xindex_0','Yampl_0', 'Yphase_0', 'DPDampl_0', ...
        'DPDphase_0','DPDPolyampl','DPDPolyphase')
    save('init2','Poly_ampl','Poly_phase')
else
    save('step1result_cor','BeforeNA','AfterNA')
    save('DPD_vec_cor', 'Xampl_0', 'Xindex_0','Yampl_0', 'Yphase_0', 'DPDampl_0', ...
    'DPDphase_0','DPDPolyampl','DPDPolyphase')
    save('init2cor','Poly_ampl','Poly_phase')
end
end

