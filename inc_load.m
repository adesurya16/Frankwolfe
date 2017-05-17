function [nilai_akhir, tabel_arus, tabel_cost] = inc_load(status_pel, tar, ukuran, filename)

    % Baca file
    fid = fopen(filename, 'r');

    % Inisialisasi parameter
    jumlah_pembebanan = fscanf(fid, 'Jumlah Pembebanan : %d', 1);
    for i=1:9
        fgets(fid); % Skip line
    end
    link = fscanf(fid, '\n\n Link : %d\n',1);
    fgets(fid); % Skip line
    fungsi_biaya = fscanf(fid,'%d %d %d %c %c-%c %d %d\n',[8 link])';

    jumlah_perjalanan = fscanf(fid, 'Asal Tujuan : %d', 1);
    asal_tujuan = fscanf(fid, '%d-%d : %f\n', [3 jumlah_perjalanan])';

    jumlah_pelabuhan = fscanf(fid, '\nPelabuhan : %d\n');
    pelabuhan = fscanf(fid, '%d\n', [1 jumlah_pelabuhan]);

    tabel_arus = zeros(1,link);
    tabel_cost = hitung_cost(tabel_arus, fungsi_biaya, tar, ukuran);

    % Mulai pembebanan
    for h=1:jumlah_pembebanan
        for i=1:jumlah_perjalanan
            
            % Dijkstra
            rute_min = dijkstra(asal_tujuan(i,1),asal_tujuan(i,2),fungsi_biaya,tabel_cost,status_pel,pelabuhan);

            % Tambah arus di tabel arus
            for j=1:size(rute_min,2)
                o = rute_min(1,j);
                tabel_arus(1,o) = tabel_arus(1,o)+(asal_tujuan(i,3)/jumlah_pembebanan);
            end
        end
        
        % Update Tabel Cost
        tabel_cost = hitung_cost(tabel_arus, fungsi_biaya, tar, ukuran);
        
    end

    % Biaya Transportasi
    biaya_trans = 0;
    for i=1:link
        biaya_trans = biaya_trans + tabel_arus(1,i) * tabel_cost(1,i);
    end
    
    nilai_akhir = biaya_trans;
    
    fclose(fid);

    % Clear variabel
    clear ans;