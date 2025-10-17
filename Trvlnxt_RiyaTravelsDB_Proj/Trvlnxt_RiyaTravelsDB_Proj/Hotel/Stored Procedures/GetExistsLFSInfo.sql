    
--==================================================================================================================================    
-- Author: Akash Singh        
-- Create date: 17 Feb 2025        
-- Description: TO Update The LFS Check Record for each booking with certain Details.        
-- EXEC Hotel.[GetExistsLFSInfo] 'TNHAPI00098829'
--==================================================================================================================================    
    
CREATE Proc Hotel.[GetExistsLFSInfo]     
@BookingId Varchar(250)=''

AS     
BEGIN  

	 Select top 1 BookingId,
	              Cast(ISNULL(PreviousRate,0) as decimal(16,2)) as PreviousCheapestRate,
	              Cast(ISNULL(Rate,0) as decimal(16,2)) as LastCheckedRate,
				  LastCheckDate,
				  SupplierName 
				  from hotel.LFSDetails 
	 where BookingId=@BookingId and 
	 MethodCheck='PriceCheck'
END    
    