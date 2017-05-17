clc;
clear all;

% Parameter PSO
filename = 'skenario.txt';
[jumlah_pel, link] = baca_file(filename);
number_particle = 4;
inertia_weight = 1;
matrix_eksisting = zeros(1,jumlah_pel);
[nilai_eksisting, ~, ~] = inc_load(matrix_eksisting, 0, 0, filename);
batas_loop = 10;

% Inisialisasi
matrix_pbest = zeros(number_particle,jumlah_pel+2);
nilai_pbest = zeros(number_particle,1);
matrix_gbest = zeros(1,jumlah_pel+2);
nilai_gbest = 0;
loop_ke = 0;
tabel_arus_best = zeros(1,link);
tabel_cost_best = zeros(1,link);

while (loop_ke <= batas_loop)
    
    % Matrix velocity
    if (loop_ke == 0)
        matrix_v = zeros(number_particle,jumlah_pel+2);
    else
        for i=1:number_particle
            for j=1:jumlah_pel+2
                matrix_v(i,j) = (matrix_v(i,j) * inertia_weight) + (2 * random_1 * (matrix_pbest(i,j) - matrix_pos(i,j))) + (2 * random_2 * (matrix_gbest(1,j) - matrix_pos(i,j)));
            end
        end
    end

    % Matrix sig
    matrix_sig = zeros(number_particle,jumlah_pel+2);
    for i=1:number_particle
        for j=1:jumlah_pel+2
            matrix_sig(i,j) = 1/(1+exp(-1 * matrix_v(i,j)));
        end
    end

    % Bilangan random
    matrix_rand = zeros(number_particle,jumlah_pel+2);
    for i=1:number_particle
        for j=1:jumlah_pel+2
            matrix_rand(i,j) = rand;
        end
    end

    % Matrix pos
    matrix_pos = zeros(number_particle,jumlah_pel+2);
    for i=1:number_particle
        for j=1:jumlah_pel+2
            if (matrix_rand(i,j) <= matrix_sig(i,j))
                matrix_pos(i,j) = 1;
            else
                matrix_pos(i,j) = 0;
            end
        end
    end

    % Matrix pbest
    for i=1:number_particle
        array_pel = zeros(1,jumlah_pel);
        for j=1:jumlah_pel
            array_pel(1,j) = matrix_pos(i,j);
        end
        tarif = matrix_pos(i,jumlah_pel+1);
        ukuran = matrix_pos(i,jumlah_pel+2);
        [nilai_akhir, tabel_arus, tabel_cost] = inc_load(array_pel, tarif, ukuran, filename);
        if (nilai_eksisting - nilai_akhir > nilai_pbest(i,1))
            for j=1:jumlah_pel+2
                matrix_pbest(i,j) = matrix_pos(i,j);
            end
            nilai_pbest(i,1) = nilai_eksisting - nilai_akhir;
        end
        
        if (nilai_eksisting - nilai_akhir > nilai_gbest)
            tabel_arus_best = tabel_arus;
            tabel_cost_best = tabel_cost;
        end
    end

    % Gbest
    [gbest, idx_best] = max(nilai_pbest);
    for i=1:jumlah_pel+2
        matrix_gbest(1,i) = matrix_pbest(idx_best,i);
    end
    nilai_gbest = gbest;
    
    % 2 bilangan random
    random_1 = rand;
    random_2 = rand;
    
    % Cek kondisi berhenti
    loop_ke = loop_ke + 1;

end

sprintf('%0.3f', nilai_gbest)

% Clear variabel yg tidak penting
clear ans;
clear array_pel;
clear array_pos;
clear berhenti;
clear biaya_ling;
clear filename;
clear gbest;
clear i;
clear idx_best;
clear j;
clear loop_ke;
clear matrix_eksisting;
clear nilai_akhir;
clear tabel_arus;
clear tabel_cost;