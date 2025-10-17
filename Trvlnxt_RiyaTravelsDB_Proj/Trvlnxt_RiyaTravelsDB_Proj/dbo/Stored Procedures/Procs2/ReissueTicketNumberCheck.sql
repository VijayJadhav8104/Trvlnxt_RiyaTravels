              
CREATE proc [dbo].[ReissueTicketNumberCheck] --[ReissueTicketNumberCheck] '','','PM2MNL','PM2MNL','Indigo'          
@depFrom varchar(10) = null            
,@depTo varchar(10) = null            
,@gdspnr varchar(20) = null           
,@TicketNumber varchar(30)=null   
,@VendorName varchar(50) = null               
as              
begin             
       
 if (@VendorName != '' and @VendorName != 'null' and @VendorName is not null)    
 begin  
     Select b.BookingStatus From tblBookMaster b WITH(NOLOCK)
	 inner join tblPassengerBookDetails p WITH(NOLOCK) on b.pkId =p.fkBookMaster            
	 Where b.OrderID IN (Select top 1 orderId from tblBookItenary WITH(NOLOCK) where airlinePNR = @GDSPNR)  
 end   
 else  
 begin  
     Select b.BookingStatus From tblBookMaster b WITH(NOLOCK)          
     inner join tblPassengerBookDetails p WITH(NOLOCK) on b.pkId =p.fkBookMaster          
     Where GDSPNR = @gdspnr and b.BookingStatus = 1    
     and (p.TicketNumber like '%'+@TicketNumber + '%' OR p.ticketNum like '%'+@TicketNumber + '%' )        
 end               
end                  
--select * from sectors 