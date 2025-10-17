CREATE procedure SearchErpDataLogs  
@Riyapnr varchar(15)  
as  
BEGIN  
select * from WinYatraDataLog where fk_bookmasterId in (  
select pid from tblPassengerBookDetails where fkbookmaster in (  
select pkId from tblBookMaster where riyapnr = @Riyapnr  
)  
)  
END