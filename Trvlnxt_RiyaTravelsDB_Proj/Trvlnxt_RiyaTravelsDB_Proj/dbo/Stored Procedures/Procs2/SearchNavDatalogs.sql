Create procedure SearchNavDatalogs   
@Riyapnr varchar(15)    
as    
BEGIN    
select * from NewERPData_Log where FK_tblbookmasterID in (    
select pid from tblPassengerBookDetails where fkbookmaster in (    
select pkId from tblBookMaster where riyapnr = @Riyapnr    
)    
) 
end