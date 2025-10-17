CREATE PROCEDURE FetchTimeLimitdataGDS
AS                          
BEGIN                          
   select GDSPNR
  ,OfficeID
  ,riyaPNR
  ,b.OrderID
  ,BookingStatus
  ,HoldTimeLimitflag
  ,AgentID
  ,b2b.AddrEmail as emailId
  ,MainAgentId from tblBookMaster b                    
  inner join agentLogin  r on r.UserID=b.AgentID            
  inner join B2BRegistration as b2b on b2b.FKUserID = b.AgentID          
  where (HoldTimeLimitflag=0 or HoldTimeLimitflag is null)                
  and BookingStatus=2 and (BookingSource='Web' OR BookingSource='API')       
  and totalFare > 0    
  and VendorName='AMADEUS' and AgentID !='B2C' and GDSPNR is not null              
  and GDSPNR != '' and (TicketIssuanceError is null OR TicketIssuanceError = '')                    
  and inserteddate_old>=getdate()-5        
  and GDSPNR NOT IN     
  (      
	 select GDSPNR from tblBookMaster as book    
	 where book.IsBooked = 1 and book.BookingStatus = 1 and book.totalFare > 0    
	 and book.VendorName='AMADEUS' and book.AgentID!='B2C'                  
	 and book.inserteddate_old>=getdate()-5      
  )  
END                     
                
--select * from tblBookMaster where riyaPNR='HV9A68' order by 1 desc                
                    
  --select getdate()