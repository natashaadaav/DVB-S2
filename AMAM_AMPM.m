%% ���������� ������������ ��������� � ���� ������� �� ������ ��������� �� ��������� �� �����
% [���������������� �� ����������� �������� ��������� �������� �������,
% �������, ����������� ����������� ���������� ������������ ���������]:
[Xampl,Xindex]=sort(abs(BeforeNA)); 
% �������� ��������� ��������� �������:
Yampl=abs(AfterNA);
% �������� ���� ��������� �������:
Yphase = angle(AfterNA.*conj(BeforeNA));

%% ������������ ������������
figure;
[hAx,hLine1,hLine2] = plotyy(Xampl,Yampl(Xindex),Xampl,Yphase(Xindex));
hLine1.LineStyle = '-';
hLine1.LineWidth = 2;
hLine2.LineStyle = '-';
hLine2.LineWidth = 2;

xlabel('��������� ������� �� ����� ��')
ylabel(hAx(1),'��������� ������� �� ������ ��') % left y-axis
ylabel(hAx(2),'�������� ���� ������� �� ������ ��, ���') % right y-axis
grid on
legend('AM/AM','AM/PM')
