


--================================================
-- Created by Shivkumar Prajapati
-- Creation Date : 21/10/2020
-- Desc : Log the api calling 
-- EXEC HotelB2cExceptionlogInExec 'string','string','string'
--================================================
CREATE procedure HotelB2cExceptionlogInExec
@Excetion nvarchar(max),
@Sbrecord nvarchar(max),
@ErrorGenerated nvarchar(50)

as
begin 

insert into  HotelB2cExceptionlog(Exception,Sbrecord,InsertedDate,ErrorGenerated) values (@Excetion,@Sbrecord,SWITCHOFFSET(SYSDATETIMEOFFSET(),'+05:30'),@ErrorGenerated)

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[HotelB2cExceptionlogInExec] TO [rt_read]
    AS [dbo];

