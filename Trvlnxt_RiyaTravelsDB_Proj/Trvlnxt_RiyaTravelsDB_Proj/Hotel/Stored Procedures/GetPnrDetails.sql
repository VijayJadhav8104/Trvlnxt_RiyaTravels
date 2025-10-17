
--Created By: Sam    
--Date : 17/11/2023    
--Details: to get the Pnr Details (session , cotrol num, s token, sequence Nu)    
CREATE Proc [Hotel].GetPnrDetails    
@PNR varchar(100) =null    
AS    
BEGIN    
       
   Select ISNULL(SSTS,null) as 'SSTS',Currency as 'Currency', Amount,CancellationToken  from [hotel].tblApiRetrivePNRData where PNR=@PNR    
    
END  