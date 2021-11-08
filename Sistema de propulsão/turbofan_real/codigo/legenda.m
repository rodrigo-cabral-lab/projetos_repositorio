function leg = legenda_(campo, str)
    hLeg = findobj(gcf,'Type', 'Legend');
    if length(hLeg) > 0
        leg = hLeg.String;
    else
        leg = {};    
    end
    
    if strcmp(campo,'')
        leg{end+1} = ['$',str,'$'];
    else
        len = length(leg);
        for i=len+1:length(campo)+len
            leg{i} = ['$',str,num2str(campo(i-len)),'$'];
        end
    end
    leg = legend(leg, 'Interpreter','Latex','Location','Best');
    leg.FontSize = 11;
end