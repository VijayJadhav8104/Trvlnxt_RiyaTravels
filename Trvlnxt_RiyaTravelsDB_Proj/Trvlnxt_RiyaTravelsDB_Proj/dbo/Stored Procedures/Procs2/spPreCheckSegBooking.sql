      
CREATE proc [dbo].[spPreCheckSegBooking]      
@paxFName varchar(100),      
@paxLName varchar(100),      
@From varchar(10),      
@To varchar(10),      
@depDate varchar(50),--'20230606'      
@arrivalDate varchar(50),--'20230606'      
@airlineCode varchar(3),      
@flightNum varchar(10),      
@mobileNum varchar(50),      
@emailID varchar(100)      
as      
begin      
 --select orderId from tblBookMaster b inner join       
 --tblPassengerBookDetails p on fkBookMaster =b.pkid      
 --where 1=1 --convert(varchar,inserteddate_old,112)>=convert(varchar,GETDATE()-1,112) --and 
 select b.orderId from tblBookItenary b with (nolock) inner join       
 tblPassengerBookDetails p with (nolock) on p.fkBookMaster =b.fkBookMaster  
 inner join tblBookMaster m with (nolock) on m.pkId=b.fkBookMaster
 where 1=1  
 and GDSPNR IS NOT NUll      
 --and IsBooked=1   
 --and b.BookingStatus=1    
 and b.frmSector= @From      
 and b.toSector= @To      
 and convert(varchar,b.depDate,112)= @depDate      
 and convert(varchar,b.arrivalDate,112)=@arrivalDate      
 and paxFName=@paxFName and paxLName=@paxLName      
 and b.airCode=@airlineCode      
 and b.flightNo=@flightNum      
 --and mobileNo=@mobileNum      
 --and emailId=@emailID      
end

--exec spPreCheckSegBooking 'HEIDI ANTIPORDA','PARANGAN','ILO','MNL','20230722','20230722','5J','452','',''