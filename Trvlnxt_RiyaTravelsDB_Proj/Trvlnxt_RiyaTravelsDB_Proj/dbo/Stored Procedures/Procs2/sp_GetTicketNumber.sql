CREATE proc [dbo].[sp_GetTicketNumber]--[dbo].[sp_GetTicketNumber] 'DEL','DXB','5YIZKB'          
@GDSPNR varchar(10) = null        
,@riyapnr varchar(10) = null        
          
as          
begin         
          
select TicketNumber from tblPassengerBookDetails where fkBookMaster IN 
		   (select top 1 pkid from tblBookMaster where GDSPNR = @GDSPNR and riyaPNR = @riyapnr)

end 