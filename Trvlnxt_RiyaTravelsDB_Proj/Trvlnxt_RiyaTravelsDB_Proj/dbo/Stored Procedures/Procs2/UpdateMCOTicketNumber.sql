CREATE procedure UpdateMCOTicketNumber 
@GDSPNR VARCHAR(50)
, @MCOTicketNumber VARCHAR(255) 
as 
begin 
UPDATE tblBookMaster set MCOTicketNumber=@MCOTicketNumber where gdspnr=@GDSPNR 
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateMCOTicketNumber] TO [rt_read]
    AS [dbo];

