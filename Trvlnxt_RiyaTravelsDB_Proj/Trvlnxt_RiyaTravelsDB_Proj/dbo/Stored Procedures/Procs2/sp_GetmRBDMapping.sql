    
CREATE Procedure [sp_GetmRBDMapping]  --[sp_GetmRBDMapping] '681'  
    
@DealMappingID int    
    
as    
begin    
    
select * From mRBDMapping where DealMappingID = @DealMappingID    
    
end