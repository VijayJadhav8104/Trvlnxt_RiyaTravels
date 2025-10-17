create procedure USPGetTicketingaccessdata  
@GDSPNR varchar(10)  
  
as begin   
 select * from tblAmadeusQueAndEmails where GDSPNR=@GDSPNR  
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPGetTicketingaccessdata] TO [rt_read]
    AS [dbo];

