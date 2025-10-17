
create proc [dbo].[GetAllPassThroughMaster]
AS
BEGIN
		BEGIN
			SELECT 
				Id,
				Airlinename,
				Percentage,
				FairType
				FROM 
					PassThroughMaster
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllPassThroughMaster] TO [rt_read]
    AS [dbo];

