CREATE proc Get_CanPolicyResponse  
@id int  
 As   
 BEgin   
   select Api_Response from HotelB2BRequestResponseLogs where Id=@id ;  
 ENd
-----
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_CanPolicyResponse] TO [rt_read]
    AS [dbo];

