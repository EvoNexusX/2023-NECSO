function [group_elements, group_index] = find_particle_group(groups, particle_index)
    
    for group_index = 1:length(groups)
        if ismember(particle_index, groups{group_index})
            group_elements = groups{group_index};
            return;  
        end
    end
    
    group_elements = []; 
    group_index = [];  
end