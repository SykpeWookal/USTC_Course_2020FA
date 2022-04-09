%例1：uicontrol介绍


%1
hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '按一下');
set(hp1,'fontsize',24)
cmd = 'disp(''你按了我一下'')';
set(hp1,'callback',cmd)
%2 添加一个关闭按钮
hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','关闭');
set(hp2,'callback','close');

%3 添加一个显示消息的静态文本框（这段要放在最前面），并修改hp1的callback

htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '按一下');
set(hp1,'fontsize',24)
% cmd = 'disp(''你按了我一下'')';
% set(hp1,'callback',cmd)
set(hp1,'callback','set(htext1,''string'',''你按了我一下'')')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','关闭');
set(hp2,'callback','close');

%3 添加一个显示消息的静态文本框（这段要放在最前面），并修改hp1的callback

htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '按一下');
set(hp1,'fontsize',24)
% cmd = 'disp(''你按了我一下'')';
% set(hp1,'callback',cmd)
set(hp1,'callback','set(htext1,''string'',''你按了我一下'')')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','关闭');
set(hp2,'callback','close');

%3 添加一个显示消息的静态文本框（这段要放在最前面），并修改hp1的callback

htext1 = uicontrol('style','text');
set(htext1,'position',[100,320,400,60])
set(htext1,'BackgroundColor', [0 0 0])
set(htext1,'foregroundcolor',[0 1 1])
set(htext1,'fontsize',24);
set(htext1,'string','hello')

hp1 = uicontrol('style','pushbutton');
set(hp1,'position',[100,100,200,200])
set(hp1,'string', '按一下');
set(hp1,'fontsize',24)
% cmd = 'disp(''你按了我一下'')';
% set(hp1,'callback',cmd)
set(hp1,'callback','set(htext1,''string'',''你按了我一下'')')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','关闭');
set(hp2,'callback','close');

%3 添加一个显示消息的静态文本框（这段要放在最前面），并修改hp1的callback
%显示按的次数,
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
set(hp1,'string', '按一下');
set(hp1,'fontsize',24)
% cmd = 'disp(''你按了我一下'')';
% set(hp1,'callback',cmd)
pushnum = 0;
set(hp1,'callback','pushnum=pushnum+1;set(htext1,''string'',num2str(pushnum))')

hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','关闭');
set(hp2,'callback','close');

