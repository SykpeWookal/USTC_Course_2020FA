screen=get(0,'ScreenSize');
W=screen(3);H=screen(4);
figure('Color',[1,1,1],'Position',[0.2*H,0.2*H,0.6*W,0.4*H],...
       'Name','ͼ����ʾϵͳ','NumberTitle','off','MenuBar','none');
%����Plot�˵���
hplot=uimenu(gcf,'Label','&Plot');
uimenu(hplot,'Label','&Sine Wave','Call',['t=-pi:pi/20:pi;','plot(t,sin(t));',...
        'set(hgon,''Enable'',''on'');','set(hgoff,''Enable'',''on'');',...
        'set(hbon,''Enable'',''on'');','set(hboff,''Enable'',''on'');']);
uimenu(hplot,'Label','&Cosine Wave','Call',['t=-pi:pi/20:pi;','plot(t,cos(t));',...
        'set(hgon,''Enable'',''on'');','set(hgoff,''Enable'',''on'');',...
        'set(hbon,''Enable'',''on'');','set(hboff,''Enable'',''on'');']);
    %����Option�˵���
    hoption=uimenu(gcf,'Label','&Option');
    hgon=uimenu(hoption,'Label','&Grig on','Call','grid on','Enable','off');
    hgoff=uimenu(hoption,'Label','&Grig off','Call','grid off','Enable','off');
    hbon=uimenu(hoption,'Label','&Box on','separator','on','Call','box on','Enable','off');
    hboff=uimenu(hoption,'Label','&Box off','Call','box off','Enable','off');
    hfigcor=uimenu(hoption,'Label','&Figure Color','Separator','on');
    uimenu(hfigcor,'Label','&Red','Accelerator','r','Call','set(gcf,''Color'',''r'');');
    uimenu(hfigcor,'Label','&Blue','Accelerator','b','Call','set(gcf,''Color'',''b'');');
    uimenu(hfigcor,'Label','&Yellow','Call','set(gcf,''Color'',''y'');');     
    uimenu(hfigcor,'Label','&White','Call','set(gcf,''Color'',''w'');');     
    %����Quit�˵���
    uimenu(gcf,'Label','&Quit','Call','close(gcf)');
