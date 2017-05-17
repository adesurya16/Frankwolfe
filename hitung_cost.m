function [tabel_cost] = hitung_cost(tabel_arus, fungsi_biaya, tar, ukuran)
    
    % Inisialisasi variabel
    link = size(fungsi_biaya,1);
    tabel_cost = zeros(1,link);
    
    tarif_truk = 60;
    tarif_kereta = 50;
    K_truk = 20;
    K_kereta = 40;
    
    nilai_waktu = 8;
    n = 4;
    
	% Tarif SSS
    if (tar == 0)
        tarif_sss = 40;
    elseif (tar == 1)
        tarif_sss = 0.8 * 40;
    end
	
    % Kecepatan SSS
    if (ukuran == 0)
        K_sss = 20;
    elseif (ukuran == 1)
        K_sss = 40;
    end

    for i=1:link
        
        % Inisialisasi parameter
        V = tabel_arus(1,i); % volume / arus
        d = fungsi_biaya(i,7); % jarak
        C_ruas = fungsi_biaya(i,8); % kapasitas ruas truk
        
        % Tarif Transfer dan Delay Time
        
        % Moda Truk <-> Moda SSS
        if (fungsi_biaya(i,5) == 84 && fungsi_biaya(i,6) == 83) || (fungsi_biaya(i,5) == 83 && fungsi_biaya(i,6) == 84)
            tarif_transfer = 10;
            delay_time = 2;
            tarif_bm = 2;
            cd = 50;
        % Moda Truk <-> Moda Kereta
        elseif (fungsi_biaya(i,5) == 84 && fungsi_biaya(i,6) == 75) || (fungsi_biaya(i,5) == 75 && fungsi_biaya(i,6) == 84)
            tarif_transfer = 15;
            delay_time = 3;
            tarif_bm = 4;
            cd = 40;
        % Moda Kereta <-> Moda SSS
        elseif (fungsi_biaya(i,5) == 75 && fungsi_biaya(i,6) == 83) || (fungsi_biaya(i,5) == 83 && fungsi_biaya(i,6) == 75)
            tarif_transfer = 20;
            delay_time = 4;
            tarif_bm = 5;
            cd = 40;
        end
        
        % Kalau ruas = B (Transfer Link)
        if (fungsi_biaya(i,4) == 66)
            cost = tarif_transfer * d + (delay_time + tarif_bm/(1 - (V / (cd * n)))) * nilai_waktu;
        % Kalau ruas = R (Ruas)
        elseif (fungsi_biaya(i,4) == 82)
            % Moda truk
            if (fungsi_biaya(i,5) == 84)
                cost = tarif_truk * d + d / K_truk * (1 + 0.4*V + 0.6*(V/C_ruas)^2) * nilai_waktu;
            % Moda SSS
            elseif (fungsi_biaya(i,5) == 83)
                cost = tarif_sss * d + d / K_sss * nilai_waktu;
            % Moda kereta
            elseif (fungsi_biaya(i,5) == 75)
                cost = tarif_kereta * d + d / K_kereta * nilai_waktu;
            end
        end
        tabel_cost(1,i) = cost;
    end
end