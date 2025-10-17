CREATE TABLE [dbo].[tblBookMaster] (
    [pkId]                       BIGINT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [orderId]                    VARCHAR (30)     NULL,
    [frmSector]                  VARCHAR (50)     NOT NULL,
    [toSector]                   VARCHAR (50)     NOT NULL,
    [fromAirport]                VARCHAR (150)    NULL,
    [toAirport]                  VARCHAR (150)    NULL,
    [airName]                    VARCHAR (150)    NULL,
    [operatingCarrier]           VARCHAR (50)     NULL,
    [airCode]                    VARCHAR (10)     NULL,
    [equipment]                  VARCHAR (100)    NULL,
    [flightNo]                   VARCHAR (10)     NULL,
    [isReturnJourney]            BIT              CONSTRAINT [DF_tblBookMaster_isReturnJourney] DEFAULT ((0)) NULL,
    [depDate]                    DATE             NULL,
    [arrivalDate]                DATE             NULL,
    [riyaPNR]                    VARCHAR (12)     NULL,
    [taxDesc]                    VARCHAR (MAX)    NULL,
    [totalFare]                  DECIMAL (18, 2)  NULL,
    [totalTax]                   DECIMAL (18, 2)  NULL,
    [basicFare]                  DECIMAL (18, 2)  NULL,
    [deptTime]                   DATETIME         NULL,
    [canceledDate]               DATETIME         NULL,
    [arrivalTime]                DATETIME         NULL,
    [GDSPNR]                     VARCHAR (30)     NULL,
    [IsBooked]                   BIT              CONSTRAINT [DF_tblBookMaster_IsBooked] DEFAULT ((0)) NULL,
    [inserteddate]               DATETIME         CONSTRAINT [DF_tblBookMaster_inserteddate] DEFAULT (getdate()) NULL,
    [IP]                         VARCHAR (50)     NULL,
    [TotalDiscount]              MONEY            CONSTRAINT [DF_tblBookMaster_TotalDiscount] DEFAULT ((0)) NULL,
    [FlatDiscount]               INT              NULL,
    [CancellationCharge]         INT              NULL,
    [ServiceCharge]              INT              NULL,
    [promoCode]                  VARCHAR (50)     NULL,
    [GovtTax]                    INT              NULL,
    [mobileNo]                   VARCHAR (20)     NULL,
    [emailId]                    VARCHAR (50)     NULL,
    [returnFlag]                 BIT              CONSTRAINT [DF_tblBookMaster_returnFlag] DEFAULT ((0)) NULL,
    [travClass]                  VARCHAR (50)     NULL,
    [fromTerminal]               VARCHAR (20)     NULL,
    [toTerminal]                 VARCHAR (20)     NULL,
    [TotalTime]                  VARCHAR (10)     NULL,
    [CounterCloseTime]           INT              NULL,
    [Remarks]                    VARCHAR (1000)   NULL,
    [YRTax]                      DECIMAL (18, 2)  NULL,
    [INTax]                      DECIMAL (18, 2)  NULL,
    [JNTax]                      DECIMAL (18, 2)  NULL,
    [OCTax]                      DECIMAL (18, 2)  NULL,
    [ExtraTax]                   DECIMAL (18, 2)  NULL,
    [YQTax]                      DECIMAL (18, 2)  NULL,
    [UserID]                     BIGINT           NULL,
    [CommissionType]             INT              NULL,
    [ServiceChargeType]          INT              NULL,
    [FlatDiscountType]           INT              NULL,
    [CancellationChargeType]     INT              NULL,
    [FareSellKey]                VARCHAR (MAX)    NULL,
    [JourneySellKey]             VARCHAR (MAX)    NULL,
    [IATACommission]             INT              NULL,
    [PLBCommission]              INT              NULL,
    [IATAPercent]                DECIMAL (18, 2)  NULL,
    [PLBPercent]                 DECIMAL (18, 2)  NULL,
    [VendorCommissionPercent]    NVARCHAR (50)    NULL,
    [VendorCommissionText]       VARCHAR (50)     NULL,
    [IsIATAOnBasic]              BIT              NULL,
    [IsPLBOnBasic]               BIT              NULL,
    [GovtTaxPercent]             DECIMAL (18, 2)  NULL,
    [UniqueID]                   UNIQUEIDENTIFIER NULL,
    [BookingSource]              VARCHAR (50)     NULL,
    [SessionId]                  VARCHAR (150)    NULL,
    [LoginEmailID]               VARCHAR (50)     NULL,
    [RegistrationNumber]         VARCHAR (50)     NULL,
    [CompanyName]                VARCHAR (50)     NULL,
    [CAddress]                   VARCHAR (MAX)    NULL,
    [CState]                     VARCHAR (50)     NULL,
    [CContactNo]                 VARCHAR (50)     NULL,
    [CEmailID]                   VARCHAR (50)     NULL,
    [PromoDiscount]              INT              NULL,
    [TicketIssuanceError]        VARCHAR (2000)   NULL,
    [OfficeID]                   VARCHAR (50)     NULL,
    [Country]                    VARCHAR (2)      NULL,
    [ROE]                        DECIMAL (18, 10) NULL,
    [AgentAction]                INT              NULL,
    [AgentID]                    VARCHAR (50)     NULL,
    [AgentMarkup]                DECIMAL (18, 2)  NULL,
    [AgentDealDiscount]          NUMERIC (18, 2)  NULL,
    [SupplierCode]               NVARCHAR (50)    NULL,
    [VendorCode]                 NVARCHAR (50)    NULL,
    [TicketIssue]                BIT              NULL,
    [TotalMarkup]                DECIMAL (18, 2)  CONSTRAINT [DF_tblBookMaster_TotalMarkup_1] DEFAULT ((0)) NULL,
    [BookingType]                INT              NULL,
    [DisplayType]                INT              NULL,
    [CalculationType]            INT              NULL,
    [TicketMail]                 BIT              NULL,
    [journey]                    CHAR (1)         NULL,
    [inserteddate_old]           DATETIME         CONSTRAINT [DF_tblBookMaster_inserteddate_old] DEFAULT (getdate()) NULL,
    [Vendor_No]                  NVARCHAR (50)    NULL,
    [IATA]                       NVARCHAR (50)    NULL,
    [FareType]                   VARCHAR (50)     NULL,
    [ERPResponseID]              VARCHAR (200)    NULL,
    [PromocodeBookingType]       SMALLINT         NULL,
    [Trackid]                    VARCHAR (MAX)    NULL,
    [PricingCode]                VARCHAR (50)     NULL,
    [TourCode]                   VARCHAR (50)     NULL,
    [TicketingPCC]               VARCHAR (50)     NULL,
    [VendorName]                 VARCHAR (50)     NULL,
    [MCOAmount]                  DECIMAL (18, 2)  NULL,
    [MCOTicketNumber]            VARCHAR (50)     NULL,
    [TotalEarning]               DECIMAL (18, 2)  NULL,
    [MainAgentId]                INT              CONSTRAINT [DF_tblBookMaster_MainAgentId] DEFAULT ((0)) NULL,
    [BookingStatus]              SMALLINT         NULL,
    [AgentInvoiceNumber]         VARCHAR (50)     NULL,
    [IsCryptic]                  INT              NULL,
    [IssueBy]                    INT              NULL,
    [IssueDate]                  DATETIME2 (7)    CONSTRAINT [DF_tblBookMaster_IssueDate] DEFAULT (getdate()) NULL,
    [InquiryNo]                  VARCHAR (50)     NULL,
    [FileNo]                     VARCHAR (50)     NULL,
    [PaymentRefNo]               VARCHAR (50)     NULL,
    [OBTCNo]                     VARCHAR (50)     NULL,
    [RTTRefNo]                   VARCHAR (50)     NULL,
    [OpsRemark]                  VARCHAR (50)     NULL,
    [AcctsRemark]                VARCHAR (50)     NULL,
    [ModifiedOn]                 DATETIME2 (7)    NULL,
    [Cancelledby]                INT              NULL,
    [CancelledDate]              DATETIME         NULL,
    [BookingTrackModifiedOn]     DATETIME2 (7)    NULL,
    [BookingTrackModifiedBy]     INT              NULL,
    [BookedBy]                   INT              NULL,
    [ClosedBy]                   INT              NULL,
    [ClosedDate]                 DATETIME2 (7)    NULL,
    [AgentROE]                   DECIMAL (18, 10) NULL,
    [ServiceFee]                 DECIMAL (18, 2)  NULL,
    [GST]                        DECIMAL (18, 2)  NULL,
    [B2BMarkup]                  DECIMAL (18, 4)  DEFAULT ((0)) NULL,
    [B2bFareType]                INT              DEFAULT ((0)) NULL,
    [BFC]                        DECIMAL (18)     NULL,
    [IsGhost]                    BIT              DEFAULT ((0)) NULL,
    [PKForderNum]                VARCHAR (50)     NULL,
    [DisplaySelfBalanceReport]   BIT              CONSTRAINT [DF_tblBookMaster_DisplaySelfBalanceReport] DEFAULT ((1)) NOT NULL,
    [ReissueCharges]             DECIMAL (18, 4)  NULL,
    [PreviousRiyaPNR]            VARCHAR (30)     NULL,
    [PromoDiscountTotalAMT]      DECIMAL (18)     NULL,
    [AERTicketTicketingDate]     DATETIME         NULL,
    [AERTicketFlowID]            VARCHAR (100)    NULL,
    [AERTicketFareTicketingDate] DATETIME         NULL,
    [YMTax]                      DECIMAL (18, 2)  NULL,
    [WOTax]                      DECIMAL (18, 2)  NULL,
    [OBTax]                      DECIMAL (18, 2)  NULL,
    [RFTax]                      DECIMAL (18, 2)  NULL,
    [AgentCurrency]              VARCHAR (30)     NULL,
    [AddUserSelfBalance]         VARCHAR (50)     NULL,
    [TotalHupAmount]             DECIMAL (18, 2)  NULL,
    [TFBookingRef]               VARCHAR (500)    NULL,
    [TFBookingstatus]            VARCHAR (150)    NULL,
    [ValidatingCarrier]          VARCHAR (50)     NULL,
    [FlightDuration]             VARCHAR (200)    NULL,
    [TotalCarbonEmission]        VARCHAR (50)     NULL,
    [HoldText]                   VARCHAR (MAX)    NULL,
    [HoldTimeLimitflag]          BIT              CONSTRAINT [DF_tblBookMaster_HoldTimeLimitflag] DEFAULT ((0)) NULL,
    [HoldDate]                   DATETIME         NULL,
    [TotalflightLegMileage]      VARCHAR (100)    NULL,
    [DiscountGstTDS]             DECIMAL (18, 2)  NULL,
    [TripType]                   VARCHAR (50)     NULL,
    [TransactionId]              VARCHAR (50)     NULL,
    [IsMultiTST]                 BIT              NULL,
    [IsNegofare]                 BIT              NULL,
    [APITrackID]                 VARCHAR (MAX)    NULL,
    [ServiceFeeMap]              DECIMAL (18, 2)  NULL,
    [ServiceFeeAdditional]       DECIMAL (18, 2)  NULL,
    [TotalVendorServiceFee]      DECIMAL (18, 2)  NULL,
    [VendorServiceFeeOn]         VARCHAR (50)     NULL,
    [ERPPush]                    BIT              NULL,
    [CancellationROE]            DECIMAL (18, 10) NULL,
    [Isfakebooking]              BIT              NULL,
    [NetAmount]                  DECIMAL (18, 2)  NULL,
    [GrossFare]                  DECIMAL (18, 2)  NULL,
    [TotalLonServiceFee]         DECIMAL (18, 2)  NULL,
    [NewIssueDate]               DATETIME2 (7)    CONSTRAINT [DF_tblBookMaster_IssueDate1] DEFAULT (getdate()) NULL,
    [HoldBookingDate]            DATETIME         NULL,
    [PGMarkup]                   DECIMAL (18, 2)  NULL,
    [K7Tax]                      DECIMAL (18, 4)  NULL,
    [BookingDate]                DATETIME         NULL,
    [Actioncodes_EY]             VARCHAR (MAX)    NULL,
    [SubBookingSource]           VARCHAR (50)     NULL,
    [ParentOrderID]              VARCHAR (255)    NULL,
    [Remark]                     VARCHAR (200)    NULL,
    [BookingFrom]                VARCHAR (50)     NULL,
    CONSTRAINT [PK_tblBookMaster] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_riyapnr]
    ON [dbo].[tblBookMaster]([riyaPNR] ASC)
    INCLUDE([depDate]);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_orderId]
    ON [dbo].[tblBookMaster]([orderId] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_AgentID]
    ON [dbo].[tblBookMaster]([AgentID] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-ismultiTST]
    ON [dbo].[tblBookMaster]([IsMultiTST] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_inserteddate_old]
    ON [dbo].[tblBookMaster]([inserteddate_old] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_inserteddate]
    ON [dbo].[tblBookMaster]([inserteddate] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_GDSPNR]
    ON [dbo].[tblBookMaster]([GDSPNR] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_VendorName]
    ON [dbo].[tblBookMaster]([VendorName] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_BookingSource]
    ON [dbo].[tblBookMaster]([BookingSource] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_BookingStatus]
    ON [dbo].[tblBookMaster]([BookingStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_airCode]
    ON [dbo].[tblBookMaster]([airCode] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_Country]
    ON [dbo].[tblBookMaster]([Country] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_OfficeID]
    ON [dbo].[tblBookMaster]([OfficeID] ASC);


GO
CREATE NONCLUSTERED INDEX [tblBookMaster_totalFare]
    ON [dbo].[tblBookMaster]([totalFare] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-promocode]
    ON [dbo].[tblBookMaster]([promoCode] ASC);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_CompositeIndex]
    ON [dbo].[tblBookMaster]([IsBooked] ASC, [BookingStatus] ASC, [pkId] ASC)
    INCLUDE([riyaPNR]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_CompositeIndex_2]
    ON [dbo].[tblBookMaster]([returnFlag] ASC, [Country] ASC)
    INCLUDE([orderId], [frmSector], [toSector], [airCode], [riyaPNR], [GDSPNR], [inserteddate], [BookingSource], [AgentID], [IssueDate], [AgentCurrency], [AgentROE]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_Index_22]
    ON [dbo].[tblBookMaster]([IsBooked] ASC, [totalFare] ASC, [inserteddate] ASC, [Country] ASC, [AgentID] ASC, [VendorName] ASC, [Isfakebooking] ASC)
    INCLUDE([orderId], [frmSector], [toSector], [airCode], [equipment], [flightNo], [depDate], [arrivalDate], [riyaPNR], [deptTime], [arrivalTime], [GDSPNR], [TotalDiscount], [travClass], [fromTerminal], [toTerminal], [CounterCloseTime], [IATACommission], [VendorCommissionPercent], [BookingSource], [RegistrationNumber], [OfficeID], [Vendor_No], [MainAgentId], [BookingStatus], [IssueDate], [AgentROE], [B2bFareType], [ValidatingCarrier]);


GO
CREATE TRIGGER [dbo].[trgInserteddate] ON dbo.tblBookMaster    
FOR INSERT    
AS    
    
declare @inserteddate Datetime;    
declare @Country varchar(10);    
Declare @utcdate Datetime;    
Declare @Id int    
    
select @inserteddate=i.inserteddate,@Country=i.Country,@Id=i.pkId,    
@utcdate =(case i.Country when 'US' THEN DATEADD(MINUTE,-570,getdate())   
when 'CA' THEN  DATEADD(MINUTE,-750,getdate())   
when 'AE' THEN DATEADD(MINUTE,-90,getdate())  ELSE  GETDATE() END) from tblBookMaster i;     
    
    
Update tblBookMaster Set inserteddate_old = @inserteddate,    
  inserteddate=@utcdate ,IssueDate =  @utcdate  
   Where pkId = @Id 