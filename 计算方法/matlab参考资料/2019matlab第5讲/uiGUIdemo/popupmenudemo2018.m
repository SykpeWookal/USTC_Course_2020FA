%��1��uicontrol����֮�ű�GUI
function popupmenudemo2018
%%Pushbutton 
%1
hp1 = uicontrol('style','popupmenu');
set(hp1,'position',[100,100,150,50],'string','one|two|three')


%2 ���һ���رհ�ť
hp2 = uicontrol('style','pushbutton');
set(hp2,'position',[320,100,200,200])
set(hp2,'fontsize',24);
set(hp2,'string','?�ر�');
set(hp2,'callback','close');

%3 ���һ����ʾ��Ϣ�ľ�̬�ı��򣬲�
%�޸�hp1��callback
htext1 = uicontrol('style','text',...
     'position',[100,320,400,60],...
     'fontsize',24,...
     'backgroundcolor',[0 0 0],...
     'foregroundcolor',[0 1 1],...
     'string','hello');
     
 %4�޸�popupmenu��callback
 set(hp1,'callback',@popupcallback);
 
    function popupcallback(src,event)
     
        val1 =get(hp1,'value');
        str1 = get(hp1,'string');
        strtext = str1(val1,:);
        set(htext1,'string',strtext,'foregroundcolor',rand(3,1));
    end

 
 
end
