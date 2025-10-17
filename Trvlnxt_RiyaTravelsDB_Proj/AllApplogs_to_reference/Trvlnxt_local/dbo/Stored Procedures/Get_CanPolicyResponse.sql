  
Create proc [dbo].[Get_CanPolicyResponse]  
@id int  
 As   
 BEgin   
   select Api_Response from [StoreLogs].[dbo].HotelB2BRequestResponseLogs where Id=@id ;  
 ENd

