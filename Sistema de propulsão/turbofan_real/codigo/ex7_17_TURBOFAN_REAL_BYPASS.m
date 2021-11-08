%% TURBOFAN REAL BYPASS OTIMO
clc
clear all
format long
ctrl = 1;
%% DADOS
T0 = 390;
Tt4 = 2500;

yc = 1.4;
yt = 1.3;

Cpc = 0.240;
Cpt = 0.296;

hPR = 18400;

pidmax = 0.95;
pifn = 1;
pib = 0.92;
pin = 0.97;

ef = 0.82;
ec = 0.84;
et = 0.85;

etab = 0.94;
etam = 0.99;

P0P9 = 1;
P0P19 = 1;

pifan = 1:0.05:10;

% pic = 24;
piC = 1:0.1:40;

% M = 0:0.1:2.5;
M0 = 0.9;

gc = 32.174;

%%
k = 1;
% for M0 = M
for pic = piC
    m = 1;
    for pif = pifan
        
        Rc = ((yc-1)/yc)*Cpc*778.16;
        Rt = ((yt-1)/yt)*Cpt*778.16;
        
        a0 = sqrt(yc*Rc*gc*T0);
        V0 = a0*M0;
        
        talr = 1+(((yc-1)/2)*M0^2);
        pir = talr^(yc/(yc-1));
        
        if M0 <= 1
            etar = 1;
        else
            etar = 1-(0.075*(M0-1)^1.35);
        end
        
        pid = pidmax*etar;
        
        tallambda = (Cpt*Tt4)/(Cpc*T0);
        
        talc = pic^((yc-1)/(yc*ec));
        etac = ((pic^((yc-1)/yc))-1)/(talc-1);
        
        talf = pif^((yc-1)/(yc*ef));
        etaf = ((pif^((yc-1)/yc))-1)/(talf-1);
        
        f = (tallambda-(talr*talc))/(((etab*hPR)/(Cpc*T0))-tallambda);
        
        Pt19P19 = P0P19*pir*pid*pif*pifn;
        M19 = sqrt((2/(yc-1))*((Pt19P19^((yc-1)/yc))-1));
        T19T0 = (talr*talf)/(Pt19P19^((yc-1)/yc));
        V19a0 = M19*sqrt(T19T0);
        V19 = a0*M19*sqrt(T19T0);
        
        PI = (pir*pid*pic*pib*pin)^((yt-1)/yt);
        
        %%
        V19V0 = V19/V0;
        erro = 10^-5;
        x = (1/PI)+((1/(tallambda*(talr-1)))*((1/(2*etam))*((talr*(talf-1))/(V19V0-1)))^2);
        xx = ((x^((et-1)/et))/(PI))+(1/(tallambda*(talr-1)))*((1/(2*etam))*((talr*(talf-1))...
            /(V19V0-1))*(1+(((1-et)/et)*((x^(-1/et))/(PI)))))^2;
        while xx-x > erro
            xx = ((x^((et-1)/et))/(PI))+(1/(tallambda*(talr-1)))*((1/(2*etam))*((talr*(talf-1))...
                /(V19V0-1))*(1+(((1-et)/et)*((x^(-1/et))/(PI)))))^2;
            x = xx;
            
        end
        talt_e = x;
        
        %%
% alfa_e = 8;
% talt_e = 1-((1/(etam*(1+f)))*(talr/tallambda)*(talc-1+(alfa_e*(talf-1))));

        pit = talt_e^(yt/((yt-1)*et));
        etat = (1-talt_e)/(1-(talt_e^(1/et)));
        alfa_e = ((etam*(1+f)*tallambda*(1-talt_e))-(talr*(talc-1)))/...
            (talr*(talf-1));
        
        Pt9P9 = P0P9*pir*pid*pic*pib*pit*pin;
        M9 = sqrt((2/(yt-1))*((Pt9P9^((yt-1)/yt))-1));
        T9T0 = (tallambda*talt_e*Cpc)/((Pt9P9^((yt-1)/yt))*Cpt);
        V9a0 = M9*sqrt((yt*Rt*T9T0)/(yc*Rc));
        
        Fmdot0 = (a0/gc)*(alfa_e/(1+alfa_e))*(V19a0-M0+((T19T0*(1-P0P19))/(V19a0*yc)))+...
            (a0/gc)*(1/(1+alfa_e))*(((1+f)*V9a0)-M0+((1+f)*(Rt/Rc)*((T9T0*(1-P0P9))/(V9a0*yc))));
        
        S = f/((1+alfa_e)*Fmdot0);
%         S = S * 10^6;
        S = S * 3600;
        
        FR = (((1+f)*V9a0)-M0+((1+f)*(Rt/Rc)*((T9T0*(1-P0P9))/(V9a0*yc))))/...
            (V19a0-M0+((T19T0*(1-P0P19))/(V19a0*yc)));
        
        etaT = (a0^2*(((1+f)*V9a0^2)+(alfa_e*V19a0^2)-(1+alfa_e)*M0^2))/(2*gc*f*hPR);
        etaP = (2*M0*(((1+f)*V9a0)+(alfa_e*V19a0)-(1+alfa_e)*M0))/(((1+f)*V9a0^2)+(alfa_e*V19a0^2)-(1+alfa_e)*M0^2);
        eta0 = etaT*etaP;
        
        if imag(V9a0)~=0
            Fmdot0 = nan;
            S = nan;
            FR = nan;
            f = nan;
            alfa_e = nan;
            etaT = nan;
            etaP = nan;
            eta0 = nan;
        end
                
        Fm(k,m) = Fmdot0;
        S1(k,m) = S;
        f1(k,m) = f;
        alfa_e1(k,m) = alfa_e;
        etaT1(k,m) = etaT;
        etaP1(k,m) = etaP;
        eta01(k,m) = eta0;
        
        if Fmdot0 > 13 && S < 1.0
            intervalo_pic(ctrl) = pic;
            intervalo_pif(ctrl) = pif;
            ctrl=ctrl+1;
        end
        
        m = m +1;
    end
    k = k +1;
end

% % %%
% figure(1)
% %yyaxis left
% plot(piC,Fm)
% xlabel('\pi_c');
% ylab = ylabel('F/$\dot{m}_{0}$');
% set(ylab,'Interpreter','latex');
% set(gca,'YMinorTick','on')
% % yyaxis right
% % plot(piC,alfa_e1)
% % ylim([0 25]);
% % ylabel('\alpha*');
% set(gca,'XMinorTick','on','YMinorTick','on')
% grid on
% 
% figure(2)
% plot(piC,S1)
% xlabel('\pi_c');
% ylabel('S');
% set(gca,'XMinorTick','on','YMinorTick','on')
% grid on
% 
% %%
% % figure(1)
% % yyaxis left
% % plot(M,Fm)
% % xlim([0 3]);
% % ylim([0 400]);
% % xlabel('M_0');
% % ylab = ylabel('F/$\dot{m}_{0}$');
% % set(ylab,'Interpreter','latex');
% % set(gca,'YMinorTick','on')
% % yyaxis right
% % plot(M,alfa_e1)
% % ylim([0 40]);
% % ylabel('\alpha*');
% % set(gca,'XMinorTick','on','YMinorTick','on') 
% % grid on
% 
% % figure(2)
% % plot(M,S1);
% % xlim([0 3]);
% % ylim([5 40]);
% % xlabel('M_0');
% % ylabel('S');
% % set(gca,'XMinorTick','on','YMinorTick','on')
% % grid on

max_pif = max(intervalo_pif)
min_pif = min(intervalo_pif)
max_pic = max(intervalo_pic)
min_pic = min(intervalo_pic)