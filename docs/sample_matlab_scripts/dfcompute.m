function [bestS, bestQ] = dfcompute(ts,winwidth,shift,numrepeat,GAMMA,OMEGA)
% Default values: window width=30, shift=1
% This function will generate cell array to feed in the dynamic community
% detection algorithm
    if nargin < 1
        error('ts required');
    end
    if nargin < 2
        winwidth = 30;
    end
    if nargin < 3
        shift =1;
    end
    
    if nargin < 4
        numrepeat =4;
    end
    
    if nargin < 5
        GAMMA =1;
    end
    
    if nargin < 6
        OMEGA =1;
    end

    nt = size(ts,2);
    dfcarray = cell(1,nt-winwidth+1); %define an empty array; what dimension?
    j=1;
    
    for step_init = 1:shift:(nt-winwidth+1) %(ncol-window+1)/slide
 %       step_init
        [r,p] = corrcoef( ts(:, ((1:winwidth) + step_init-1))');
        r(isnan(r))=0;
	indx = tril(ones(size(r)),-1);
        p_l_bh = mafdr(p(indx==1),'BHFDR',true); %mafdr on p-values
        r_bh = 0*r;
        r_bh(indx==1) =  r(indx==1) .* (p_l_bh<0.05);
        r_bh = double(r_bh + r_bh');
        dfcarray{1,j}=abs(r_bh);
        j=j+1;
    end

    [B,twom] = multiord_f(dfcarray,GAMMA,OMEGA);
    tmpS = cell(numrepeat,1);tmpQ = zeros(numrepeat,1);
 
    parfor k = 1:numrepeat %this step takes long time, use 100 for now
        rng(k)       %control random generator
        [tmpS{k,1},tmpQ(k,1)] = genlouvain(B,10000,0);
    end
    tmpQ=tmpQ/twom;
   
    bestloc = find(tmpQ == max(tmpQ));
    bestS = reshape(tmpS{bestloc,1},size(ts,1),size(dfcarray,2));
    bestQ = tmpQ(bestloc,1);
    
end

