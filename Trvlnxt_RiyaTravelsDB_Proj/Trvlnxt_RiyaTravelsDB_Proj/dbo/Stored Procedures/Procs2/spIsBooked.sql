    
CREATE proc [dbo].[spIsBooked]--[dbo].[spIsBooked] 'DEL','DXB','5YIZKB'    
@depFrom varchar(10) = null  
,@depTo varchar(10) = null  
,@gdspnr varchar(20) = null  
    
as    
begin   
    
 Select BookingStatus From tblBookMaster Where frmSector = @depFrom and toSector = @depTo and GDSPNR = @gdspnr 
 and BookingSource != 'Cryptic'
     
end        
--select * from sectors 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spIsBooked] TO [rt_read]
    AS [dbo];

