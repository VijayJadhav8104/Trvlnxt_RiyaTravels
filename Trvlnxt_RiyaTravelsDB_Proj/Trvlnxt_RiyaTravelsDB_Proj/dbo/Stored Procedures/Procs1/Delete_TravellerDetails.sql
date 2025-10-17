CREATE proc [dbo].[Delete_TravellerDetails] --10048

@ID int
as begin

update tblTraveller
set DeleteFlag= 1
where TravellerID = @ID


end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_TravellerDetails] TO [rt_read]
    AS [dbo];

