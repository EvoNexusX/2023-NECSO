%Ackley function
function y = fitness(x)
    y = zeros(length(x(:,1)),1);
    for i = 1 : length(x(:,1))
        t = x(i,:);
        A = 10;
        n = length(t);
        y(i) = A * n + sum(t.^2 - A * cos(2 * pi * t));
    end
end
