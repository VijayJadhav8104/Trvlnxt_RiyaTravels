



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getPlanDetails] 
	-- Add the parameters for the stored procedure here
	@ID int =0,
	@planID int=1,
	@planName varchar(100)=null,
	@areaName varchar(35),
    @minDays varchar(35),
    @maxDays varchar(35),
    @minAge varchar(35),
    @maxAge varchar(35),
    @benefits varchar(max)=null,
    @deductible varchar(100)=null,
    @limits varchar(100)=null,
	@updatedDate datetime=null,
	@InsurerName varchar(15)=null,
	@ErrorText varchar(max)=null,
	@Flag varchar(15)
AS
BEGIN	
if(@Flag='DELETE')
	BEGIN	
		Truncate table Ins_planDetails; 
	END
else if(@Flag='INSERT')
	BEGIN
		INSERT INTO Ins_planDetails(planID,planName,areaName,minDays,maxDays,minAge,maxAge,benefits,deductible,limits,updatedDate,InsurerName)      
		VALUES (@planID,@planName,@areaName,@minDays,@maxDays,@minAge,@maxAge,@benefits,@deductible,@limits,GETDATE(),@InsurerName)    
	END
END





