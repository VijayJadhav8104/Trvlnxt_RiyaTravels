
--exec GetRiyaPnrBookingCount 'R16ME5'
 --exec GetRiyaPnrBookingCount '5IKT18'
CREATE PROCEDURE  [dbo].[GetRiyaPnrBookingCount]    
    
@riyaPNR varchar(30)=NULL
   
AS    
BEGIN    

   Declare @GdsPNR  VARCHAR(100) 
   Set @GdsPNR = (Select top 1 gdspnr from tblbookmaster where riyaPNR=@riyaPNR) 

    select count(riyaPNR) from tblbookmaster
	     where GDSPNR= @GdsPNR 
		      and BookingStatus=1 group by riyaPNR

END 
