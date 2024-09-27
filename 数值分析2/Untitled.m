function Untitled
    clc
 
    A = [
        1e-8  2  3;
        -1  3.712  4.623;
        -2  1.072  5.643;
        ];
    b = [1;  2;  3;];
    
    x1 = Solve(A, b)
    x2 = Solve_imp(A, b)
    
    A = [
        4  -2  4;
        -2  17  10;
        -4  10  9;
        ];
    b = [10;  3;  7;];
    
    x1 = Solve(A, b)
    x2 = Solve_imp(A, b)
    
end

function [x] = Solve(A, b)
    %第一列
    b(2) = b(2) - b(1)*( A(2,1) / A(1,1) );
    A(2,:) = A(2,:) - A(1,:)*( A(2,1) / A(1,1) );
    b(3) = b(3) - b(1)*( A(3,1) / A(1,1) );
    A(3,:) = A(3,:) - A(1,:)*( A(3,1) / A(1,1) );
    
    %第二列
    b(3) = b(3) - b(2)*( A(3,2) / A(2,2) );
    A(3,:) = A(3,:) - A(2,:)*( A(3,2) / A(2,2) );
    
    %带入求值
    x3 = b(3) / A(3,3);
    
    x2 = b(2) - x3 * A(2, 3);
    x2 = x2 / A(2, 2);
    
    x1 = b(1) - x2 * A(1, 2) - x3 * A(1, 3);
    x1 = x1 / A(1, 1);
    
    x = [x1; x2; x3];
end

function [x] = Solve_imp(A, b)
    %选主元
    [n, p] = max(abs(A(:, 1)));
    temp = [];
    temp = A(1, :);
    A(1, :) = A(p, :);
    A(p, :) = temp;
    temp_b = b(1);
    b(1) = b(p);
    b(p) = temp_b;

    x = Solve(A, b);
end