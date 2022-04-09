%例1：uicontrol介绍之脚本GUI
function popupmenudemo2018
%%Pushbutton 
%1
hp1 = uicontrol('style','popupmenu');
set(hp1,'position',[100,100,150,50],'string','one|two|three')


%2 添加一个关闭按钮
hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','?关闭');
set(hp2,'callback','close');

%3 添加一个显示消息的静态文本框，并
%修改hp1的callback
htext1 = uicontrol('style','text',...
     'position',[100,320,400,60],...
     'fontsize',24,...
     'backgroundcolor',[0 0 0],...
     'foregroundcolor',[0 1 1],...
     'string','hello');
     
 %4修改popupmenu的callback
 set(hp1,'callback',@popupcallback);
 
    function popupcallback(src,event)
     
        val1 =get(hp1,'value');
        str1 = get(hp1,'string');
        strtext = str1(val1,:);
        set(htext1,'string',strtext,'foregroundcolor',rand(3,1));
    end

 
 
end
