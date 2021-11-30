% ����źŵ�S�任�����棬�������轵�����ź�

clc;
clear all;
alpha=5;%��ʼS�任����ֵ
T = 0.5;%����ʱ��
fs =128000; %����Ƶ��
t = 0:1/fs:T-1/fs; %ʱ��
t1=0.20001;   %��ѹ��俪ʼʱ��
t2=0.32001;   %��ѹ������ʱ��
a=0.2000001;    %��ѹ����ֵ
y = sin(2*pi*50*t);%������ѹ�ź�
ya = (1.0000000-a*(t>t1 & t<t2)).*sin(2*pi*50*t); %�������ĵ�ѹ�ź�
global td;%��ѹ���ĳ���ʱ��
global Tmin;
global Tmax;
global result;
global flag;%�����ж��Ƿ�
figure(1);
plot(t,ya);   
[st,t,f] = st_gaijin(ya,alpha,0,200,1/(fs),1);
% figure(2); 
% surf(t,f,abs(st),'EdgeColor','none');
% title('���������ĵ�ѹ�źŵ�S�任ʱ��-Ƶ��-��ֵͼ��');
% xlabel("ʱ��/s");
% ylabel("Ƶ��/Hz");
% zlabel("��ֵ");
% % figure(3);
% plot(t,abs(st(26,:)));
% title("��Ƶ��ֵ����");
% xlabel("ʱ��/s");
% ylabel("��ֵ");
% axis([0 0.5 0.35 0.5]);

%��ȡ�������
for j = 1 : T * fs-1
    st_chafen(j) = abs(st(26,j)) - abs(st(26,j+1));
end

%��ȡs�任�����ֵ����Сֵ�����ڼ���������
Amax = max(abs(st(26,:)));
Amin = min(abs(st(26,:)));

% % figure(4);
% plot(t(:,1:T*fs-1),st_chafen);
% title("��Ƶ��ֵ�����������");
% xlabel("ʱ��/s");
% ylabel("���ֵ");


Threshold = 500;%����������ļ�ֵ�����ĵ�Ĺ�����ֵ
result = [];%��ʼ��result����������Ų�����߼�ֵ��Ӧ��ʱ��

%Ѱ�Ҳ����˲�����ߵļ�ֵ��
%flag�����жϼ�ֵ���Ƿ�������ֵ����

for k = 2 : (T*fs - 2) 
    if (abs(st_chafen(k)) > abs(st_chafen(k-1))) && (abs(st_chafen(k)) > abs(st_chafen(k+1)))
        flag = 1;

        for threshold = 0 : Threshold
            if (st_chafen(k) * st_chafen(k + threshold) < 0) ||(st_chafen(k) * st_chafen(k-threshold) < 0) || (abs(st_chafen(k)) < 1e-4)
                flag = 0;
            end
        end
        if (flag == 1)
            fprintf("666\n");
            temp = zeros(2,1);
            temp = transpose([t(k) st_chafen(k) ]);
            result = [result temp];
            [stmin,minindex] = min(result,[],2);  
            Tmin = result(1,minindex(2));
            [stmax,maxindex] = max(result,[],2); 
            Tmax = result(1,maxindex(2));
            td = Tmax - Tmin;
        end
    end 
end

%������������ĳ���ʱ�䣬����֮ǰ�õ�����Ϲ�ʽ����ȡ����Ӧ����alpha_new
if (td < 0)
   t_begin = vpa(Tmax,5);
   t_end = vpa(Tmin,5);
   td = vpa(t_end - t_begin,5); 
   td_cha = vpa(td-(t2-t1),5);
   
   
   fprintf("%.5f\n",t1);
   fprintf("%.5f\n",t2);
   fprintf("�������轵\n");
   fprintf("�轵����ʱ��Ϊ: %.5fs\n",td);
   yita = vpa(Amin/Amax,7);
   fprintf("%.7f",yita);
   yita_cha = vpa((yita-1+a)/(1-a),7);
else
   t_begin = vpa(Tmax,5);
   t_end = vpa(Tmin,5);
   td = vpa(t_begin - t_end,5);
   td_cha = vpa(td-(t2-t1),5);
   fprintf("%.5f\n",t1);
   fprintf("%.5f\n",t2);
   fprintf("����������\n");
   fprintf("��������ʱ��Ϊ: %5fs\n",td);
   yita = vpa(Amax/Amin,7);
   fprintf("%.7f",yita);
   yita_cha = vpa((yita-1-a)/(1+a),7);
end
            