
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertPromoDetails]
	-- Add the parameters for the stored procedure here
	@amt decimal,
	@salesFrm date=null,
	@salesTo date=null,
	@travelFrm date=null,
	@travelTo date=null,
	@code varchar(20)=null,
	@remarks varchar(500)=null,
	
	@adminID bigint
	
	
	
	
AS
BEGIN--1
--set nocount on;
	INSERT INTO [dbo].[PromoMaster]
           ([salesFrm_date]
           ,[salesTo_date]
           ,[travelFrm_date]
           ,[travelTo_date]
           ,[Remark]
           ,[insertDate]
           ,[userID]
          ,amount
		  ,promoCode
          )

     VALUES
	 (
	 @salesFrm ,
	@salesTo ,
	@travelFrm ,
	@travelTo ,
	
	@remarks ,
	getdate()
	,@adminID
	,@amt
	,@code
	 )
END--1









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertPromoDetails] TO [rt_read]
    AS [dbo];

