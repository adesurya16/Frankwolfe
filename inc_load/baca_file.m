function [jumlah_pelabuhan, link] = baca_file(filename)

    % Mulai Baca File %
    fid = fopen(filename, 'r');
    
    for j=1:9
        fgets(fid);
    end
    
    link = fscanf(fid, '\n\n Link : %d\n',1);
    fgets(fid);
    for i=1:link
        fgets(fid);
    end
    fgets(fid);
    
    jumlah_perjalanan = fscanf(fid, 'Asal Tujuan : %d', 1);
    for i=1:jumlah_perjalanan
        fgets(fid);
    end
    fgets(fid);
    
    jumlah_pelabuhan = fscanf(fid, '\nPelabuhan : %d\n');
    
    fclose(fid);
    % Selesai Baca File %
    
end