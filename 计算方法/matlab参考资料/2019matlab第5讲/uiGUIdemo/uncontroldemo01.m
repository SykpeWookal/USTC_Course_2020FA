%��1��uicontrol����


%1
hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '��һ��');
set(hp1,'fontsize',24)
cmd = 'disp(''�㰴����һ��'')';
set(hp1,'callback',cmd)
%2 ���һ���رհ�ť
hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','�ر�');
set(hp2,'callback','close');

%3 ���һ����ʾ��Ϣ�ľ�̬�ı������Ҫ������ǰ�棩�����޸�hp1��callback

htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '��һ��');
set(hp1,'fontsize',24)
% cmd = 'disp(''�㰴����һ��'')';
% set(hp1,'callback',cmd)
set(hp1,'callback','set(htext1,''string'',''�㰴����һ��'')')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','�ر�');
set(hp2,'callback','close');

%3 ���һ����ʾ��Ϣ�ľ�̬�ı������Ҫ������ǰ�棩�����޸�hp1��callback

htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '��һ��');
set(hp1,'fontsize',24)
% cmd = 'disp(''�㰴����һ��'')';
% set(hp1,'callback',cmd)
set(hp1,'callback','set(htext1,''string'',''�㰴����һ��'')')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','�ر�');
set(hp2,'callback','close');

%3 ���һ����ʾ��Ϣ�ľ�̬�ı������Ҫ������ǰ�棩�����޸�hp1��callback

htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '��һ��');
set(hp1,'fontsize',24)
% cmd = 'disp(''�㰴����һ��'')';
% set(hp1,'callback',cmd)
set(hp1,'callback','set(htext1,''string'',''�㰴����һ��'')')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','�ر�');
set(hp2,'callback','close');

%3 ���һ����ʾ��Ϣ�ľ�̬�ı������Ҫ������ǰ�棩�����޸�hp1��callback
%��ʾ���Ĵ���,
clc
clear
htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '��һ��');
set(hp1,'fontsize',24)
% cmd = 'disp(''�㰴����һ��'')';
% set(hp1,'callback',cmd)
pushnum = 0;
set(hp1,'callback','pushnum=pushnum+1;set(htext1,''string'',num2str(pushnum))')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','�ر�');
set(hp2,'callback','close');

