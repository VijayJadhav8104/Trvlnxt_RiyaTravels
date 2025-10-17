
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertDiscountDetails1]
	@AirlineCode varchar(20)=null,
	@SectorType varchar(50)=null,
	@IATAPercent  decimal(10,1)=null,
	@IsIATAOnBasic varchar(50)=null,
	@Econ_PLBPercent decimal(10,1)=null,
	@Prem_PLBPercent decimal(10,1)=null,
	@Busn_PLBPercent decimal(10,1)=null,
	@First_PLBPercent decimal(10,1)=null,
	@IsPLBOnBasic bit,
	@SalesValidityFrom date=null,
	@SalesValidityTo date=null,
	@TravelValidityFrom date=null,
	@TravelValidityTo date=null,
	@Issue_PCC varchar(50)=null,
	@Remark varchar(500)=null,
	@userID bigint,
	@tour_code varchar(50)=null,
	@IsRBDExclude bit,
	@RBDClass varchar(30)=null,
	@IsSotoExclude bit,
	@IsSectorExclude bit,
	@ExcludedSector varchar(30)=null
AS
BEGIN

	IF((SELECT Count(*) FROM DiscountMaster1 WHERE AirlineCode=@AirlineCode AND SectorType=@SectorType AND SalesValidityFrom=@SalesValidityFrom AND 
		SalesValidityTo=@SalesValidityTo AND TravelValidityTo=@TravelValidityTo AND TravelValidityFrom=@TravelValidityFrom)>0)

		BEGIN
			select 2
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[DiscountMaster1]
				([AirlineCode]
					,[SectorType]
					,[IATAPercent]
					,[IsIATAOnBasic]
					,[Econ_PLBPercent]
					,[Prem_PLBPercent]
					,[Busn_PLBPercent]
					,[First_PLBPercent]
					,[ModifiedBy]
					,[SalesValidityFrom]
					,[SalesValidityTo]
					,[TravelValidityFrom]
					,[TravelValidityTo]
					,[Issue_PCC]
					,[Remark]
					,[userID]
					,[tour_code]
					,[IsRBDExclude]
					,[RBDClass]
					,[IsSotoExclude]
					,[IsSectorExclude]
					,[ExcludedSector]
					,[InsertDate])

			Values( @AirlineCode,
				@SectorType ,
				@IATAPercent ,
				@IsIATAOnBasic,
				@Econ_PLBPercent,
				@Prem_PLBPercent,
				@Busn_PLBPercent,
				@First_PLBPercent,
				@IsPLBOnBasic,
				@SalesValidityFrom,
				@SalesValidityTo ,
				@TravelValidityFrom,
				@TravelValidityTo,
				@Issue_PCC,
				@Remark ,
				@userID ,
				@tour_code,
				@IsRBDExclude ,
				@RBDClass,
				@IsSotoExclude ,
				@IsSectorExclude ,
				@ExcludedSector,
				getdate() )

			select 1
		END
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertDiscountDetails1] TO [rt_read]
    AS [dbo];

