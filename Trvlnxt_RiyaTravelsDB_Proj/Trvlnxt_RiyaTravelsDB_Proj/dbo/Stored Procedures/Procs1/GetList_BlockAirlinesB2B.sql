CREATE Proc [dbo].[GetList_BlockAirlinesB2B]    
    
as    
begin    
    
select * from BlockedAirlinelistB2B where btStatus=1    
    
    
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_BlockAirlinesB2B] TO [rt_read]
    AS [dbo];

