

CREATE proc [dbo].[_123]
as begin
select 1
end 

--ALTER TABLE [dbo].[tblBookMaster]
--ADD [IATACommission] [int] NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [PLBCommission] [int] NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [IATAPercent] [decimal](18, 2) NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [PLBPercent] [decimal](18, 2) NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [VendorCommissionPercent] [decimal](18, 2) NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [VendorCommissionText] [varchar](50) NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [IsIATAOnBasic] [bit] NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [IsPLBOnBasic] [bit] NULL,
	
--ALTER TABLE [dbo].[tblBookMaster]
--ADD [GovtTaxPercent] [decimal](18, 2) NULL,


-------------PASSENGER


--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [IATACommission] [int] NULL,
	
--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [PLBCommission] [int] NULL,
	
--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [GovtTaxPercent] [decimal](18, 2) NULL,
	
--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [IATAPercent] [decimal](18, 2) NULL,
	
--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [PLBPercent] [decimal](18, 2) NULL,
	
--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [IsIATAOnBasic] [bit] NULL,
	
--ALTER TABLE [dbo].[tblPassengerBookDetails]
--ADD [IsPLBOnBasic] [bit] NULL,

--USE [B2C_India]
--GO
--/****** Object:  StoredProcedure [dbo].[spInsertBookMaster]    Script Date: 8/12/2017 5:17:49 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER proc [dbo].[spInsertBookMaster]
--            @orderId varchar(30),
--			@CounterCloseTime int = null
--           ,@frmSector varchar(50)
--           ,@toSector varchar(50)
--           ,@fromAirport varchar(150)
--           ,@toAirport varchar(150)
--           ,@airName varchar(150)
--           ,@operatingCarrier varchar(50)
--           ,@airCode varchar(10)=null
--           ,@equipment varchar(100)=null
--           ,@flightNo varchar(10)
--           ,@isReturnJourney bit
--           ,@riyaPNR varchar(10)=null
--           ,@taxDesc varchar(1000)=null
--           ,@totalFare money = null
--           ,@totalTax money =null
--           ,@basicFare money =null
--           ,@deptDateTime datetime=null
--         --  ,@canceledDate datetime =null
--           ,@arrivalDateTime datetime=null
--          -- ,@GDSPNR varchar(30)=null
--         --  ,@IsBooked char(1)=null
--           ,@IP varchar(50)=null
--		   ,@GovtTax int
--           ,@TotalDiscount int
--           ,@FlatDiscount decimal(18,2)=null
--           ,@ServiceCharge decimal(18,2)=null
--           ,@CancellationCharge decimal(18,2)=null
--           ,@promoCode varchar(50)=null
--           ,@mobileNo varchar(20)
--           ,@emailId varchar(50)
--		   ,@returnFlag bit=0
--		   ,@fromTerminal varchar(20) =null
--		   ,@toTerminal varchar(20)=null
--		   ,@YrTax decimal(18,2),
--			@InTax decimal(18,2),
--			@JnTax decimal(18,2),
--			@OCTax decimal(18,2),
--			@ExtraTax decimal(18,2),
--			@YQTax  decimal(18,2),
--			@CommissionType int=null
--           ,@ServiceChargeType int=null
--           ,@FlatDiscountType int=null
--           ,@CancellationChargeType int=null
--		   ,@FareSellKey varchar (100)=null
--		   ,@JourneySellKey	 varchar (100)=null
--		   ,@TotalTime varchar(10) =null
--		   ,@IATACommission int =null
--		   ,@PLBCommission int =null
--		   ,@GovtTaxPercent decimal(18,2) =null
--		   ,@IsIATAOnBasic bit =null
--		   ,@IsPLBOnBasic int =null
--		   ,@IATAPercent decimal(18,2) =null
--		   ,@PLBPercent decimal(18,2) =null
--as
--begin
--INSERT INTO [dbo].[tblBookMaster]
--           (TotalTime,
--		    CounterCloseTime
--		   ,orderId
--           ,frmSector
--           ,toSector
--           ,fromAirport
--           ,toAirport
--           ,airName
--           ,operatingCarrier
--           ,airCode
--           ,equipment
--           ,flightNo
--           ,isReturnJourney
--           ,depDate
--           ,arrivalDate
--           ,riyaPNR
--           ,taxDesc
--           ,totalFare
--           ,totalTax
--           ,basicFare
--           ,deptTime
--         --,canceledDate
--           ,arrivalTime
--         --,GDSPNR
--        -- ,IsBooked
--           ,IP
--           ,TotalDiscount
--           ,FlatDiscount
--           ,ServiceCharge
--           ,CancellationCharge
--		   ,promoCode
--           ,mobileNo
--           ,emailId
--		   ,GovtTax
--		   ,returnFlag
--		   ,fromTerminal
--		   ,toTerminal
--		   ,YrTax
--		   ,InTax
--		   ,JnTax
--		   ,OCTax
--		   ,ExtraTax
--		   ,YQTax
--		   ,CommissionType
--		   ,ServiceChargeType
--		   ,FlatDiscountType
--		   ,CancellationChargeType
--		   ,FareSellKey 
--		   ,JourneySellKey	
--		   , IATACommission,
--		   PLBCommission,
--		   GovtTaxPercent
--		   ,IsIATAOnBasic 
--		   ,IsPLBOnBasic 
--		   ,IATAPercent 
--		   ,PLBPercent )
--     VALUES
--           (@TotalTime,@CounterCloseTime,
--		    @orderId
--           ,@frmSector
--           ,@toSector
--           ,@fromAirport
--           ,@toAirport
--           ,@airName
--           ,@operatingCarrier
--           ,@airCode
--           ,@equipment
--           ,@flightNo
--           ,@isReturnJourney
--           ,@arrivalDateTime
--           ,@arrivalDateTime
--           ,@riyaPNR
--           ,@taxDesc
--           ,@totalFare
--           ,@totalTax
--           ,@basicFare
--           ,@deptDateTime
--         --,@canceledDate
--           ,@arrivalDateTime
--         --,@GDSPNR
--         --,@IsBooked
--           ,@IP
--           ,@TotalDiscount
--           ,@FlatDiscount
--           ,@ServiceCharge
--           ,@CancellationCharge
--           ,@promoCode
--           ,@mobileNo
--           ,@emailId
--		   ,@GovtTax
--		   ,@returnFlag
--		   ,@fromTerminal
--		   ,@toTerminal
--		   ,@YrTax
--		   ,@InTax
--		   ,@JnTax
--		   ,@OCTax
--		   ,@ExtraTax
--		   ,@YQTax
--		   ,@CommissionType 
--           ,@ServiceChargeType 
--           ,@FlatDiscountType 
--           ,@CancellationChargeType 
--		   ,@FareSellKey 
--		   ,@JourneySellKey	
--		   , @IATACommission,
--		   @PLBCommission,
--		   @GovtTaxPercent
--		   ,@IsIATAOnBasic 
--		   ,@IsPLBOnBasic 
--		   ,@IATAPercent 
--		   ,@PLBPercent )

	



--  select SCOPE_IDENTITY();
	  
--end








--ALTER PROCEDURE [dbo].[UpdateTicketNo]
--@PaxId						int,
--@ticketNum					varchar(80),
--@VendorCommission			varchar(80)= null,
--@VendorCommissionText		varchar(80)= null
--AS BEGIN
	
--	UPDATE tblPassengerBookDetails SET ticketNum = @ticketNum 
--	WHERE pid = @PaxId

--	declare @BookingId int

--	Select @BookingId = [fkBookMaster] from tblPassengerBookDetails where pid = @PaxId

--	Update tblBookMaster set IsBooked = 1,VendorCommissionPercent=@VendorCommission, VendorCommissionText= @VendorCommissionText
--	where pkId = @BookingId
--END



--USE [B2C_India]
--GO
--/****** Object:  StoredProcedure [dbo].[spInserBookPassenger]    Script Date: 8/12/2017 5:18:31 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER proc [dbo].[spInserBookPassenger]
--            @fkBookMaster bigint
--           ,@paxFName varchar(50)
--           ,@paxLName varchar(50)
--           ,@passportNum varchar(30)=null
--           ,@passexp date=null
--		   ,@passPortIssueCountry varchar(100)=null
--           ,@status bit=0
--           ,@title varchar(10)=null
--           ,@dateOfBirth datetime=null
--           ,@nationality varchar(50)=null
--           ,@gender varchar(20)=null
--           --,@ticketNum varchar(30)=null
--           ,@baggage varchar(30)=null
--		   --,@YQ varchar(50)
--		   ,@paxType varchar(50)
--		   ,@totalFare money
--		   ,@basicFare money
--		   ,@totalTax money
--		   ,@YQ money=null
--		   ,@serviceCharge money
--		   ,@Discount money
--		   ,@FlatDiscount money
--		   ,@GovtTax money
--		   ,@CancellationCharge	money
--		   ,@isReturn bit,
--		    @YrTax decimal(18,2),
--			@InTax decimal(18,2),
--			@JnTax decimal(18,2),
--			@OCTax decimal(18,2),
--			@ExtraTax decimal(18,2),
--			@DiscriptionTax varchar(1000)=null,
--			@CommissionType int=null
--           ,@ServiceChargeType int=null
--           ,@FlatDiscountType int=null
--           ,@CancellationChargeType int=null
--		    ,@IATACommission int=null
--		   ,@PLBCommission int=null
--		    ,@GovtTaxPercent decimal(18,2)=null
--			 ,@IsIATAOnBasic bit=null
--		   ,@IsPLBOnBasic int=null
--		   ,@IATAPercent decimal(18,2)=null
--		   ,@PLBPercent decimal(18,2)=null
--AS
--BEGIN

--INSERT INTO [dbo].[tblPassengerBookDetails]
--           (fkBookMaster
--           ,paxFName
--           ,paxLName
--           ,passportNum
--           ,passexp
--           ,[status]
--           ,title
--           ,dateOfBirth
--           ,nationality
--           ,gender
--           ,paxType
--		   ,totalFare
--		   ,[basicFare]
--		   ,[totalTax]
--		   ,YQ
--		   ,[baggage]
--		   ,[passportIssueCountry]
--		   ,isReturn
--		   ,serviceCharge
--		   ,Discount
--		   ,FlatDiscount
--		   ,GovtTax
--		   ,CancellationCharge
--		   ,YrTax
--		   ,InTax
--		   ,JnTax
--		   ,OCTax
--		   ,ExtraTax
--		   ,DiscriptionTax
--		   ,CommissionType
--           ,ServiceChargeType
--           ,FlatDiscountType
--           ,CancellationChargeType
--		     , IATACommission,
--		   PLBCommission,
--		   GovtTaxPercent
--		    ,IsIATAOnBasic 
--		   ,IsPLBOnBasic 
--		   ,IATAPercent 
--		   ,PLBPercent )
--     VALUES
--           (
--		    @fkBookMaster
--           ,@paxFName
--           ,@paxLName
--           ,@passportNum
--           ,@passexp
--           ,@status
--           ,@title
--           ,@dateOfBirth
--           ,@nationality
--           ,@gender
--           ,@paxType
--		   ,@totalFare
--		   ,@basicFare 
--		   ,@totalTax 
--		   ,@YQ
--		   ,@baggage
--		   ,@passPortIssueCountry
--		   ,@isReturn
--		   ,@serviceCharge
--		   ,@Discount
--		   ,@FlatDiscount
--		   ,@GovtTax
--		   ,@CancellationCharge
--		   ,@YrTax
--		   ,@InTax
--		   ,@JnTax
--		   ,@OCTax
--		   ,@ExtraTax
--		   ,@DiscriptionTax
--		   ,@CommissionType 
--           ,@ServiceChargeType 
--           ,@FlatDiscountType 
--           ,@CancellationChargeType 
--		  , @IATACommission,
--		   @PLBCommission,
--		   @GovtTaxPercent 
--		    ,@IsIATAOnBasic 
--		   ,@IsPLBOnBasic 
--		   ,@IATAPercent 
--		   ,@PLBPercent )
--select SCOPE_IDENTITY();

--end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[_123] TO [rt_read]
    AS [dbo];

