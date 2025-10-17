
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertmarkupDetails]
	-- Add the parameters for the stored procedure here
	@airlineID varchar(20)=null,
	
	@amount int=null,
	@disID bigint,
	@adminID bigint,
	@opr int = 0,
	@Type		varchar(50) =null
	
AS
BEGIN
--set nocount on;
If(@airlineID='All')
begin



update [dbo].[markUpMaster] set status='D' ,[modifiedDate]=getdate(),ModifiedBy=@adminID
   
  INSERT INTO [dbo].[markUpMaster]
           ([AirCode]
           ,[amount]
           ,[insert_date]
           ,[userId]
		    ,status,ChargeType
           )
 select 
             [AirlineCode] ,
		 		    @amount ,
		getdate(),
	@adminID,'A',@Type from dbo.AirlineCode_Console


select 3

end
else
begin
if(@opr=0)	
Begin
IF NOT EXISTS(SELECT * FROM [markUpMaster] WHERE [AirCode] = @airlineID AND  ChargeType = @Type )
begin
  INSERT INTO [dbo].[markUpMaster]
           ([AirCode]
           ,[amount]
           ,[insert_date]
           ,[userId],ChargeType
           )
     VALUES
	 (@airlineID         , @amount ,
	getdate(),
	@adminID,@Type )

	select 1;
	end
	else
	begin

	UPDATE [dbo].[markUpMaster]
   SET status = 'D',[modifiedDate]=GETDATE(),ModifiedBy=@adminID
   where [AirCode] = @airlineID and ChargeType = @Type



	INSERT INTO [dbo].[markUpMaster]
           ([AirCode]
           ,[amount]
           ,[insert_date]
           ,[userId],status,ChargeType
           )
     VALUES
	 (@airlineID         , @amount ,
	getdate(),
	@adminID ,'A', @Type)

	select 1;
	end
End
Else
Begin
	
	UPDATE [dbo].[markUpMaster]
   SET --[AirCode] = @airlineID
      --,[amount] = @amount
	  Status='D'
      , [modifiedDate]=getdate()
      ,ModifiedBy = @adminID

 WHERE Pk_Id=@disID

	select 4
End	

End


END










GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertmarkupDetails] TO [rt_read]
    AS [dbo];

