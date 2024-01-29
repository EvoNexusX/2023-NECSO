% NECSO
%------------------------------- Reference --------------------------------
%Heliostat Field Layout via Niching and Elite
%Competition Swarm Optimization
clc;
clear;
%% Fixed random seed for easy debugging
s1 = RandStream('mt19937ar', 'Seed', 1); 
RandStream.setGlobalStream(s1);
%% Initialization
Dim = 15;
npop = 100*Dim;
% phi --- 0.1 --- Social factor
phi = 0.1;
% kappa: Number of particles in each group
kappa = 10;
% G: Number of groups
G = npop/kappa;
ub = 5.12;
lb = -5.12;
particles.pos = rand(npop,Dim)*(ub-lb) + lb ;
particles.vel = zeros(npop,Dim);
particles.fitness = zeros(npop,1);
particles.group = zeros(npop,1);
% the leader at which group
particles.leader = zeros(G,1);
%the number of function evaluations (NFE)
N = 100*npop;
cnt = 0;
tot = 0;
Best_fitness = zeros(N,1);
Gbest_fitness = 0x3f3f3f;
Gbest = zeros(Dim,1);
ub = repmat(ub,npop,Dim);
lb = repmat(lb,npop,Dim);
particles.fitness = fitness(particles.pos);
tot = tot + npop;
%Random grouping and find the leaders
groups = random_grouping(1:npop, kappa);
for i = 1 : G
    tgroups = sort_fitness(groups{i},particles.fitness);
    particles.leader(i) = tgroups(1);
end
%% Optimization
%Records the number of iterations without updates
noupdate = 0;
tercondition = 10;
while(tot < N)
    update = [];
    flag1 = 0;
    flag2 = 0;
    for j = 1 : npop
        [particles.vel(j,:),particles.pos(j,:),flag1] = intra_group_competition...
           (particles,j,groups,phi);
        if flag1
           update = [update,j];
        end
    end
    
    for j = 1 : G
        x = particles.leader(j);
        [particles.vel(x,:),particles.pos(x,:),flag2] = inter_group_competition...
           (particles,x,phi);
        if flag2
            update = [update,x];
        end
    end
    
    %limit the boundary
    reflect = find(particles.pos > ub);
    Position_old = particles.pos(reflect);
    particles.pos(reflect) = ub(reflect) - mod((particles.pos(reflect) - ub(reflect)), (ub(reflect) - lb(reflect)));
    particles.vel(reflect) = particles.pos(reflect) - Position_old;
    
    reflect = find(particles.pos < lb);
    Position_old = particles.pos(reflect);
    particles.pos(reflect) = lb(reflect) + mod((lb(reflect) - particles.pos(reflect)), (ub(reflect) - lb(reflect)));
    particles.vel(reflect) = particles.pos(reflect) - Position_old;

    % Evaluate and update the best ans
    cnt = cnt + 1;
    if ~isempty(update)
        particles.fitness(update) = fitness(particles.pos(update,:));
        tot = tot + 1;
    else
        noupdate = noupdate + 1;
    end
    if noupdate > tercondition
        break;
    end
    [Best_fitness(cnt),I] = min(particles.fitness);
    if Gbest_fitness >  Best_fitness(cnt)
       Gbest_fitness = Best_fitness(cnt);
       Gbest(:) = particles.pos(I,:);
    end
    %Random grouping and find the leaders
    groups = random_grouping(1:npop, kappa);
    for i = 1 : G
        tgroups = sort_fitness(groups{i},particles.fitness);
        particles.leader(i) = tgroups(1);
    end
    %print
    progress = tot / N * 100; 
    progress_str = sprintf('process: %.2f%%', progress); 
    disp(progress_str);
    disp(Best_fitness(cnt));
end

%% Draw the picture
plot(1:cnt-1,Best_fitness(1:cnt-1));
disp(Gbest_fitness);
disp(Gbest);