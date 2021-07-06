function terra = plotterra(~)

%Plot da Terra

grs80 = referenceEllipsoid('grs80','km');
ax = axesm('globe','Geoid',grs80,'Grid','off', ...
    'GlineWidth',1,'GLineStyle','-', ...
    'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
showaxes on
view(3)

%desenho (textura) da Terra

load topo
geoshow(topo,topolegend,'DisplayType','texturemap')
demcmap(topo)