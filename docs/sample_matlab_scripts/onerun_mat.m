function [Q] = onerun_mat(fn)

	addpath '../../../../matlab_funcion/GenLouvain-master';
	addpath '../../../../matlab_funcion/GenLouvain-master/HelperFunctions';
	addpath '../../../../matlab_funcion/GenLouvain-master/Assignment'
	datpath = './matreas/'


	ws = [30,20,40];
	gamma= [0.2,0.7,1.2,1.7];
	omega = [0.2,0.7,1.2,1.7];

	S=cell(1,11);
	Q=cell(1,11);

	numrepeat=30;
	Data=table2array(readtable(strcat(datpath,fn)));
	for k = 1:3
		try	
			[S{1,k},Q{1,k}]=dfcompute(Data(1:min(285,size(Data,1)),:)',ws(k),1,numrepeat,1,1);
		catch
			S{1,k}=[];Q{1,k}=[];
	
		end
	end

	save(strcat('matreas_285_',strrep(fn,'.txt','.mat')), 'S','Q')
	for k = 1:4
		try 
			[S{1,k+3},Q{1,k+3}]=dfcompute(Data(1:285,:)',30,1,numrepeat,gamma(k),1);
		catch
			S{1,k+3}=[];Q{1,k+3}=[];

		end
	end
	
	for k=1:4
		try 
			[S{1,k+7},Q{1,k+7}]=dfcompute(Data(1:285,:)',30,1,numrepeat,1, omega(k));
	
		catch
			S{1,k+7}=[];Q{1,k+7}=[];
		end	

	end
	Q
	save(strcat('matreas_285_',strrep(fn,'.txt','.mat')), 'S','Q')
end

