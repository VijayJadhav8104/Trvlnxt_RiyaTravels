CREATE proc [dbo].[spGetRiyaPNR]--[dbo].[spIsBooked] 'DEL','DXB','5YIZKB'        
@depFrom varchar(10) = null      
,@depTo varchar(10) = null      
,@gdspnr varchar(20) = null      
        
as        
begin       
        
 Select riyaPNR From tblBookMaster Where frmSector = @depFrom and toSector = @depTo and GDSPNR = @gdspnr      
         
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetRiyaPNR] TO [rt_read]
    AS [dbo];

