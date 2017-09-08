function route = dijkstra(asal, tujuan, fungsi_biaya, tabel_cost, status_pel, pelabuhan)

    link = size(fungsi_biaya,1);

    % Nonaktifkan rute sesuai status pelabuhan
    for i=1:size(pelabuhan,2)
        if(status_pel(1,i) == 0 || sum(status_pel) < 2)
            pel = pelabuhan(1,i);
            for j=1:link
                if (fungsi_biaya(j,2) == pel)
                    fungsi_biaya(j,2) = 0;
                end
                if (fungsi_biaya(j,3) == pel)
                    fungsi_biaya(j,3) = 0;
                end
            end
        end
    end
    
    % Mulai Algoritma Dijkstra
    
    % Inisialisasi tabel link (dist, prev, visited). No_link jadi indeks
    % tabel
    tabel_link = zeros(link, 3);
    for i=1:link
        tabel_link(i,1) = Inf;
        tabel_link(i,2) = Inf;
    end
    tabel_link(asal,1) = 0;
    
    % Iterasi Dijkstra
    u = asal;
    while (u ~= tujuan) % Iterasi berhenti ketika sudah sampai tujuan
        % Cari node dengan nilai dist minimum
        nilai_u = Inf;
        for l=1:link
            if (tabel_link(l,3) == 0)
                if (tabel_link(l,1) < nilai_u)
                    u = l;
                    nilai_u = tabel_link(l,1);
                end
            end
        end
        
        if (u ~= tujuan)
            % Mencari node berikutnya
            tabel_link(u,3) = 1;
            for j=1:link
                v = fungsi_biaya(j,3);
                if (v ~= 0) % Tidak lewat pelabuhan
                    if (fungsi_biaya(j,2) == u && tabel_link(v,3) == 0)
                        alt = tabel_link(u,1) + tabel_cost(1,j);
                        if (alt < tabel_link(v,1))
                            tabel_link(v,1) = alt;
                            tabel_link(v,2) = u;
                        end
                    end
                end
            end
        end
    end
    
    % Mendefinisikan path terpendek dalam node
    path = [];
    u = tujuan;
    while (tabel_link(u,2) ~= Inf)
        path = cat(2,u,path);
        u = tabel_link(u,2);
    end
    path = cat(2,u,path);
    
    % Mendefinisikan route terpendek dalam link
    route = [];
    for i=1:size(path,2)-1
        a = path(1,i);
        b = path(1,i+1);
        j = 1;
        while (fungsi_biaya(j,2) ~= a || fungsi_biaya(j,3) ~= b)
            j = j+1;
        end
        route = cat(2,route,j);
    end
    
    % Selesai Algoritma Dijkstra

end