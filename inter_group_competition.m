function [new_velocity, new_position, flag] = inter_group_competition(particles, i,phi)
    group_particles = particles.leader;
    group_mean_position = mean(particles.pos(group_particles, :));
    
    random_index = randperm(length(group_particles), 1);
    competitor_index = group_particles(random_index);
    
    Dim = length(particles.pos(1,:));
    if particles.fitness(i) > particles.fitness(competitor_index)
        % Update velocity and position
        R1 = rand(1,Dim);
        R2 = rand(1,Dim);
        R3 = rand(1,Dim);
        new_velocity = R1.*particles.vel(i, :) + R2.*(particles.pos(competitor_index, :)-particles.pos(i, :))... 
        + phi.*R3.*(group_mean_position-particles.pos(i, :));
        new_position = particles.pos(i, :) + new_velocity;
        flag = 1;
    else
        % No update if particle is inferior
        new_velocity = particles.vel(i, :);
        new_position = particles.pos(i, :);
        flag = 0;
    end
end