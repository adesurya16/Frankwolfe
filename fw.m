clc;
clear all;

% Parameter FW
filename = 'skenario_FW_2.txt'; %file yang diinput format ikutin dari gw
jumlah_iterasi = 5; %tidak dipakai karena menurut AEC
iterasi_bisection = 5; %default 5 didapat dari file
batas_AEC = 0.01;

% Mulai Baca File %
fid = fopen(filename, 'r');
link_count = fscanf(fid, '\n\n Link : %d\n',1);
fgets(fid); % Skip header link
link = fscanf(fid,'%d %d %d %c %d %f %f %d\n',[8 link_count])';
batas_AEC = fscanf(fid,'batas AEC : %f\n',1);
iterasi_bisection = fscanf(fid,'iterasi bisection : %d\n',1);
jumlah_perjalanan = fscanf(fid, 'Asal Tujuan : %d\n', 1);
asal_tujuan = fscanf(fid, '%d-%d : %d\n', [3 jumlah_perjalanan])';

% Inisialisasi
tabel_X = zeros(3,link_count);
tabel_t = zeros(1,link_count);

for i=1:link_count
    tabel_t(1,i) = link(i,6)+tabel_X(1,i)*link(i,7);
end


jumlah_arus = 0;
for i=1:jumlah_perjalanan
    jumlah_arus = jumlah_arus + asal_tujuan(i,3);
end

% Iterasi 1
fprintf('iterasi 1\n');
for i=1:jumlah_perjalanan
    rute_min = dijkstra(asal_tujuan(i,1),asal_tujuan(i,2),link,tabel_t);
    for j=1:size(rute_min,2)
        o = rute_min(1,j);
        tabel_X(1,o) = tabel_X(1,o) + asal_tujuan(i,3);
    end
end

for i=1:link_count
    tabel_t(1,i) = 10+tabel_X(1,i)/100;
end

% print tabel_X dan tabel_t
fprintf('tabel_X = [');
for index=1:link_count
    fprintf('%f ',tabel_X(1,index));
end
fprintf(']\n');

fprintf('tabel_t = [');
for index=1:link_count
    fprintf('%f ',tabel_t(1,index));
end
fprintf(']\n');

AEC = 1;
% Mulai iterasi, dari iterasi 2

 x = 1;
 while AEC > batas_AEC
%for x = 2 : jumlah_iterasi
    % Hitung AEC dan tabel X baris ke 2 (X* iterasi 2)
    AEC = 0;
     x = x + 1; 
    for i=1:link_count
        AEC = AEC + tabel_X(1,i)*tabel_t(1,i);
    end
    for i=1:jumlah_perjalanan
        rute_min = dijkstra(asal_tujuan(i,1),asal_tujuan(i,2),link,tabel_t);
        for j=1:size(rute_min,2)
            o = rute_min(1,j);
            tabel_X(2,o) = tabel_X(2,o) + asal_tujuan(i,3);
            AEC = AEC - tabel_t(1,o) * asal_tujuan(i,3);
        end
    end
    AEC = AEC / jumlah_arus;
    
    % Bisection
    batas_bawah = 0;
    batas_atas = 1;
    for k=1:iterasi_bisection
        lambda = (batas_bawah+batas_atas)/2;
        hasil_bs = 0;
        for l=1:link_count
           hasil_bs = hasil_bs + ((tabel_X(2,l)-tabel_X(1,l)) * (((1-lambda)*tabel_X(1,l) + lambda*tabel_X(2,l))/100 + 10));
        end
        if (hasil_bs > 0)
            % Buang batas atas
            batas_atas = lambda;
        elseif (hasil_bs < 0)
            % Buang batas bawah
            batas_bawah = lambda;
        end
    end
    last_lambda = (batas_bawah+batas_atas)/2;
    
    % Update tabel X dan tabel t
    for m=1:link_count
        tabel_X(3,m) = last_lambda*tabel_X(2,m) + (1-last_lambda)*tabel_X(1,m);
    end
    for m=1:link_count
        tabel_X(1,m) = tabel_X(3,m);
        tabel_X(2,m) = 0;
        tabel_t(1,m) = 10+tabel_X(1,m)/100;
    end
    fprintf('\niterasi %d\n',x);
    fprintf('AEC : %f\n',AEC);
    %disp('Last lambda : ');
    %disp(last_lambda);
    fprintf('Last lamda : %f\n',last_lambda);
    % print tabel_X dan tabel_t
    fprintf('tabel_X = [');
    for index=1:link_count
        fprintf('%f ',tabel_X(1,index));
    end
    fprintf(']\n');

    fprintf('tabel_t = [');
    for index=1:link_count
        fprintf('%f ',tabel_t(1,index));
    end
    fprintf(']\n');
 end
 
 nilai_akhir = 0;
 for i=1:link_count
    nilai_akhir = nilai_akhir + tabel_t(1,i) * tabel_X(1,i);
 end
 
 % Inisialisasi Tabel Arus
    tabel_arus = zeros(1,link_count);
    for i=1:link_count
        tabel_arus(1,i) = tabel_t(1,i);
    end
    
 % Inisialisasi Tabel Cost
    tabel_cost = zeros(1,link);
    for i=1:link_count
        tabel_cost = tabel_X(1,i);
    end
    
fclose(fid);