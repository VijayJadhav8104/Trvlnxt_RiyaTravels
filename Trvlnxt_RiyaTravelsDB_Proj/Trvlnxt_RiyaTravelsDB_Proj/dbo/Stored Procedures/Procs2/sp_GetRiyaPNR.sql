         
CREATE PROCEDURE [dbo].[sp_GetRiyaPNR]             
 -- Add the parameters for the stored procedure here            
 @GDSPNR VARCHAR(10)          
 ,@depFrom varchar(10) = null                  
 ,@depTo varchar(10) = null        
 ,@ticketNumber varchar(50) = null  
 ,@VendorName varchar(50) = null  
AS            
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 -- interfering with SELECT statements.            
 SET NOCOUNT ON;
 if (@VendorName != '' and @VendorName != 'null' and @VendorName is not null)    
 begin  
     Select top 1 b.riyaPNR as RiyaPNR   
     From tblBookMaster b inner join tblPassengerBookDetails p on b.pkId =p.fkBookMaster            
     Where b.OrderID IN (Select top 1 orderId from tblBookItenary where airlinePNR = @GDSPNR)  
 end  
 else if @depFrom != '' and @depFrom != 'null'          
 begin          
    declare @bookingSource varchar(MAX) = 'Retrive PNR,Retrive PNR Accounting,Retrieve PNR accounting - MultiTST,Web,ManualTicketing,Desktop,Mobile,offlineDesktop,Retrive PNR Accounting-TicketNumber,GDS'          
    select top 1 riyaPNR as RiyaPNR from tblBookMaster where GDSPNR=@GDSPNR and frmSector = @depFrom and toSector = @depTo          
    and BookingSource IN ( select Data from sample_split(@bookingSource,','))            
 end      
 else if @ticketNumber != '' and @ticketNumber != 'null'          
 begin      
     Select top 1 b.riyaPNR as RiyaPNR From tblBookMaster b inner join tblPassengerBookDetails p on b.pkId =p.fkBookMaster            
     Where GDSPNR = @GDSPNR and (p.TicketNumber like '%'+@ticketNumber + '%' OR p.ticketNum like '%'+@ticketNumber + '%' )              
 end        
 else          
 begin          
    select top 1 riyaPNR as RiyaPNR from tblBookMaster where GDSPNR=@GDSPNR order by inserteddate desc            
 end          
 END   
  
  
  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetRiyaPNR] TO [rt_read]
    AS [dbo];

