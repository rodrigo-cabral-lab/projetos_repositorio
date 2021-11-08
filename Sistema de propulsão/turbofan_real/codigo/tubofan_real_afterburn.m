function[Fmo, f, fab, fo,  S, alfa, nT, nP, nO, etac, etat]  = tubofan_real_afterburn(ask, Mo, To, hpr, gamac, cpc, gamat, cpt, gamaab, cpab, Tt4, Tt7, PoP9, pidmax, pic, pib, pif, piab, pimmax, pin, ef, ec, et, nb, nab, nm, M6)

Rc = (gamac-1)*cpc/gamac;
Rt = (gamat-1)*cpt/gamat;
Rab = (gamaab-1)*cpab/gamaab;
ao = sqrt(gamac*Rc*To);
Vo = ao*Mo;
talr = 1+(Mo^2)*(gamac-1)/2;
pir = talr^(gamac/(gamac-1));
if Mo <=1 
    nr = 1;
else
    nr = 1-0.075*((Mo-1)^1.35);
end
pid = pidmax*nr;
taly = (cpt*Tt4)/(cpc*To);
talyab = (cpab*Tt7)/(cpc*To);
talc = pic^((gamac-1)/(gamac*ec));
etac = (pic^((gamac-1)/gamac)-1)/(talc-1);
talf = pif^((gamac-1)/(gamac*ef));
nf = (pif^((gamac-1)/gamac)-1)/(talf-1);
f = (taly -talr*talc)/(((nb*hpr)/(cpc*To))-taly);
alfa = (nm*(1+f)*(taly/talr)*(1-((pif/(pic*pib))^((gamat-1)*et/gamat)))-talc+1)/(talf-1);
talt = 1 - (talr*(talc-1+alfa*(talf-1)))/(nm*(1+f)*taly);
pit = talt^(gamat/((gamat-1)*et));
etat = (1-talt)/(1-talt^(1/et));
Pt16Pt6 = pif/(pic*pib*pit);
M16 = sqrt((2/(gamac-1))*(((Pt16Pt6*((1+(M6^2)*(gamat-1)/2)^(gamat/(gamat-1))))^((gamac-1)/gamac))-1));
alfalinha = alfa/(1+f);
cp6a = (cpt+alfalinha*cpc)/(1+alfalinha);
R6a = (Rt+alfalinha*Rc)/(1+alfalinha);
gama6a=cp6a/(cp6a-R6a);
Tt16Tt6 = (To*talr*talf)/(Tt4*talt);
talm = (cpt/cp6a)*((1+alfalinha*(cpc/cpt)*Tt16Tt6)/(1+alfalinha));
Phi6 = (M6^2)*(1+(M6^2)*(gamat-1)/2)/((1+gamat*(M6^2))^2);
Phi16 = (M6^2)*(1+(M16^2)*(gamac-1)/2)/((1+gamac*(M16^2))^2);
Phi6a = (R6a*gamat*talm/(Rt*gama6a))*(((1+alfalinha)/((1/sqrt(Phi6))+alfalinha*sqrt((Rc*gamat*Tt16Tt6)/(Rt*gamac*Phi16))))^2);
M6a = sqrt((2*Phi6a)/(1-2*gama6a*Phi6a+sqrt(1-2*(gama6a+1)*Phi6a)));
A16A6 = alfalinha*sqrt(Tt16Tt6)/((M16/M6)*sqrt((gamac*Rt/(gamat*Rc))*((1+(M16^2)*(gamac-1)/2)/(1+(M6^2)*(gamat-1)/2))));
gama6 = gamat;
R6 = Rt;
MFP6 = M6*sqrt(gama6/R6)/((1+(M6^2)*(gama6-1)/2)^((gama6+1)/(2*(gama6-1))));
MFP6a = M6a*sqrt(gama6a/R6a)/((1+(M6a^2)*(gama6a-1)/2)^((gama6a+1)/(2*(gama6a-1))));
pimideal = (1+alfalinha)*sqrt(talm)*MFP6/((1+A16A6)*MFP6a);
pim = pimmax*pimideal;
Pt9P9 = PoP9*pir*pid*pic*pib*pit*pim*piab*pin;

if ask == 'D'
    cp9 = cp6a;
    R9 = R6a;
    gama9 = gama6a;
    T9To = ((Tt4*talt*talm)/To)/(Pt9P9^((gama6a-1)/gama6a));
    fab = 0;
else
    cp9 = cpab;
    R9 = Rab;
    gama9 = gamaab;
    fab = (1+f/(1+alfa))*(talyab-(cp6a/cpt)*taly*talt*talm)/(((nab*hpr)/(cpc*To)) - talyab);
    T9To = (Tt7/To)/(Pt9P9^((gamaab-1)/gamaab));
end


M9 = sqrt((2/(gama9-1))*(Pt9P9^((gama9-1)/gama9)-1));
V9ao = M9*sqrt((gama9*R9*T9To)/(gamac*Rc));
fo = (f/(1+alfa))+fab;
Fmo = ao*((1+fo)*V9ao-Mo+(1+fo)*(R9*T9To*(1-PoP9))/(Rc*V9ao*gamac));
S = (10^6)*(fo)/(Fmo);
nT = (ao^2)*((1+fo)*(V9ao^2)-(Mo^2))/(2*(fo)*hpr);
nP = (2*Vo*Fmo)/((ao^2)*((1+fo)*(V9ao^2)-(Mo^2)));
nO = nP*nT;

assignin('base', 'pir', pir);
assignin('base', 'pid', pid);
assignin('base', 'pic', pic);
assignin('base', 'pit', pit);
assignin('base', 'talr', talr);
assignin('base', 'talc', talc);
assignin('base', 'talt', talt);
assignin('base', 'alfa', alfa);
assignin('base', 'M9', M9);
assignin('base', 'Fmo', Fmo);
assignin('base', 'f', f);
assignin('base', 'S', S);
assignin('base', 'nT', nT);
assignin('base', 'nP', nP);
assignin('base', 'nO', nO);
assignin('base', 'etat', etat);
assignin('base', 'etac', etac);
end