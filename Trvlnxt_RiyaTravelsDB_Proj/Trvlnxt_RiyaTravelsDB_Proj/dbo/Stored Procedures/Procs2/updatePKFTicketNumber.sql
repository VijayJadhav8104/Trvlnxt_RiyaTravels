  
CREATE PROCEDURE [dbo].[updatePKFTicketNumber]  
 @OrderNum varchar (50),  
 @ticketNum varchar (50),  
 @firstname varchar (50),  
 @lastname varchar (50),  
 @sex varchar (50),  
 @IsReturn int  
  
AS  
BEGIN  
   
 update p   
  
 set p.ticketNum=@ticketNum  ,p.TicketNumber=@ticketNum
   
 from tblPassengerBookDetails as p  
  
 inner join tblBookMaster as b on p.fkBookMaster=b.pkId  
   
 where b.PKForderNum=@OrderNum and returnFlag=@IsReturn and paxFName=@firstname and paxLName=@lastname and gender=@sex 
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[updatePKFTicketNumber] TO [rt_read]
    AS [dbo];

