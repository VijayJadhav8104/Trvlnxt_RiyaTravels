

CREATE PROCEDURE [dbo].[insertServiceChargesDetails]
	-- Add the parameters for the stored procedure here
	@airlineID varchar(20)=null,
	
	@amount int=null,
	@disID bigint,
	@adminID bigint,
	@opr int = 0,
	@Type		varchar(50) =null,
	@ServiceChargeType int=null
	
AS
BEGIN
--set nocount on;
If(@airlineID='All')
begin



update [dbo].[ServiceCharges] set [IsActive]=0 ,[ModifiedDate]=getdate(),[ModifiedBy]=@adminID  where  [SectorType] = @Type
   
  INSERT INTO [dbo].[ServiceCharges]
           ([AirCode]
           ,[amount]
           ,[Insert_date]
           ,[UserId]
		    ,[IsActive]
			,[SectorType]
			,ServiceChargeType
           )
 select 
             [AirlineCode] ,
		 		    @amount ,
		getdate(),
	@adminID,1,@Type,@ServiceChargeType from dbo.AirlineCode_Console


select 3

end
else
begin
if(@opr=0)	
Begin
IF NOT EXISTS(SELECT * FROM [ServiceCharges] WHERE [AirCode] = @airlineID AND  [SectorType] = @Type)
begin
  INSERT INTO [dbo].[ServiceCharges]
           ([AirCode]
           ,[amount]
           ,[Insert_date]
           ,[UserId]
		   ,[SectorType]
		   ,ServiceChargeType
           )
     VALUES
	 (@airlineID         , @amount ,
	getdate(),
	@adminID,@Type,@ServiceChargeType )

	select 1;
	end
	else
	begin

	UPDATE [dbo].[ServiceCharges]
   SET  [IsActive]= 0,[modifiedDate]=GETDATE(),ModifiedBy=@adminID
   where [AirCode] = @airlineID and [SectorType] = @Type 



	INSERT INTO [dbo].[ServiceCharges]
           ([AirCode]
           ,[amount]
           ,[Insert_date]
           ,[userId]
		   ,[IsActive]
		   ,[SectorType]
		   ,ServiceChargeType
           )
     VALUES
	 (@airlineID, @amount ,	getdate(),	@adminID ,1, @Type,@ServiceChargeType)

	select 1;
	end
End
Else
Begin
	
	UPDATE [dbo].[ServiceCharges]
   SET --[AirCode] = @airlineID
      --,[amount] = @amount
	  [IsActive]=0
      , [modifiedDate]=getdate()
      ,ModifiedBy = @adminID


 WHERE PkId=@disID

	select 4
End	

End


END










GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertServiceChargesDetails] TO [rt_read]
    AS [dbo];

