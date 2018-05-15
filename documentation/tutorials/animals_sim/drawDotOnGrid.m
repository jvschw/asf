function drawDotOnGrid (windowPtr, aTexture, nx, ny, ix, iy, screenDimX, screenDimY, textureDimX, textureDimY)
%example
%draw a texure on the lower left position of a 7x5 grid (xGridPosition1, yGridPosition 5)
%
%IMAGINARY GRID
%1, 1	2, 1	3, 1	4, 1	5, 1	6, 1	7, 1
%1, 2	2, 2	3, 2	4, 2	5, 2	6, 2	7, 2
%1, 3	2, 3	3, 3	4, 3	5, 3	6, 3	7, 3
%1, 4	2, 4	3, 4	4, 4	5, 4	6, 4	7, 4
%1, 5	2, 5	3, 5	4, 5	5, 5	6, 5	7, 5
%
%drawCenteredTexure (windowPtr, aTexture, 7, 5, 1, 5, 1024, 768, [20, 20])


vx = ((1:nx) - mean(1:nx))/nx;
vy = ((1:ny) - mean(1:ny))/ny;

cx = vx(ix)*screenDimX;
cy = vy(iy)*screenDimY;

Screen('DrawDots', windowPtr, [ cx, cy], 15 )





