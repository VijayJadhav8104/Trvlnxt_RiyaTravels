CREATE TABLE [dbo].[Hotel_BookMaster] (
    [pkId]                                 BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [orderId]                              VARCHAR (30)    NULL,
    [expected_prize]                       VARCHAR (20)    NULL,
    [searchApiId]                          VARCHAR (200)   NOT NULL,
    [hotelId]                              VARCHAR (50)    NOT NULL,
    [section_unique_id]                    VARCHAR (100)   NULL,
    [book_Id]                              VARCHAR (150)   NULL,
    [AgentId]                              VARCHAR (150)   NULL,
    [book_message]                         VARCHAR (50)    CONSTRAINT [DF_Hotel_BookMaster_book_message] DEFAULT ('Pending') NULL,
    [BookingReference]                     VARCHAR (150)   NULL,
    [riyaPNR]                              VARCHAR (10)    NULL,
    [ConfirmationNumber]                   VARCHAR (50)    NULL,
    [TotalCharges]                         DECIMAL (10, 2) NULL,
    [LeaderTitle]                          VARCHAR (6)     NULL,
    [LeaderFirstName]                      VARCHAR (150)   NULL,
    [LeaderLastName]                       VARCHAR (150)   NULL,
    [CurrencyCode]                         VARCHAR (10)    NULL,
    [HotelName]                            VARCHAR (150)   NULL,
    [CountryName]                          VARCHAR (150)   NULL,
    [CityId]                               VARCHAR (150)   NULL,
    [HotelAddress1]                        VARCHAR (650)   NULL,
    [CurrentStatus]                        VARCHAR (50)    NULL,
    [ExpirationDate]                       DATETIME        NULL,
    [TotalAdults]                          VARCHAR (10)    NULL,
    [TotalChildren]                        VARCHAR (10)    NULL,
    [TotalRooms]                           VARCHAR (10)    NULL,
    [HotelAddress2]                        VARCHAR (650)   NULL,
    [ServiceDate]                          DATETIME        NULL,
    [CheckInDate]                          DATETIME        NULL,
    [CheckOutDate]                         DATETIME        NULL,
    [AgentRate]                            DECIMAL (10, 2) NULL,
    [HotelPhone]                           VARCHAR (50)    NULL,
    [HotelRating]                          VARCHAR (20)    NULL,
    [SelectedNights]                       VARCHAR (20)    NULL,
    [CancellationPolicy]                   VARCHAR (MAX)   NULL,
    [AgentRefNo]                           VARCHAR (30)    NULL,
    [PassengerPhone]                       VARCHAR (50)    NULL,
    [PassengerEmail]                       VARCHAR (150)   NULL,
    [totalTax]                             DECIMAL (10, 2) NULL,
    [IsCancelled]                          INT             NULL,
    [IsBooked]                             INT             NULL,
    [inserteddate]                         DATETIME        NULL,
    [TotalDiscount]                        DECIMAL (10, 2) NULL,
    [CancellationCharge]                   DECIMAL (10, 2) NULL,
    [ServiceCharge]                        DECIMAL (10, 2) NULL,
    [promoCode]                            VARCHAR (50)    NULL,
    [request]                              VARCHAR (1500)  NULL,
    [cityName]                             VARCHAR (100)   NULL,
    [CancelHours]                          DECIMAL (18, 2) NULL,
    [IsRefunded]                           INT             NULL,
    [RefundedProcessRemark]                VARCHAR (50)    NULL,
    [aftermarkupcancelcharges]             NUMERIC (18, 2) NULL,
    [CancelDate]                           DATETIME        NULL,
    [ContractComment]                      NVARCHAR (MAX)  NULL,
    [QtechCancelCharge]                    NUMERIC (18, 2) NULL,
    [QtechTotalCharges]                    NUMERIC (18, 2) NULL,
    [QtechAppliedAgentCharges]             NUMERIC (18, 2) NULL,
    [QtechAppliedAgentRate]                NUMERIC (18, 2) NULL,
    [BufferCancelDate]                     DATETIME        NULL,
    [SupplierName]                         VARCHAR (200)   NULL,
    [beforecancelcharge]                   NUMERIC (18, 2) NULL,
    [AppliedAgentCharges]                  DECIMAL (10, 2) NULL,
    [LoginID]                              VARCHAR (500)   NULL,
    [IsClosed]                             INT             NULL,
    [SupplierRate]                         DECIMAL (10, 2) NULL,
    [SupplierCurrencyCode]                 VARCHAR (10)    NULL,
    [ROEValue]                             DECIMAL (18, 6) NULL,
    [SupplierPhoneNo]                      VARCHAR (100)   NULL,
    [SupplierReferenceNo]                  VARCHAR (200)   NULL,
    [ClosedRemark]                         VARCHAR (1000)  NULL,
    [FullRefund]                           BIT             NULL,
    [HotelConfNumber]                      VARCHAR (MAX)   NULL,
    [OfflineRemark]                        VARCHAR (MAX)   NULL,
    [AddCancelCharge]                      INT             NULL,
    [RiyaAgentID]                          NVARCHAR (50)   NULL,
    [ERPStatus]                            BIT             NULL,
    [RoomType]                             NVARCHAR (500)  NULL,
    [AdminNote]                            NVARCHAR (500)  NULL,
    [HotelStaffName]                       VARCHAR (100)   NULL,
    [ConfirmationRemark]                   NVARCHAR (500)  NULL,
    [ConfirmationDate]                     DATETIME        NULL,
    [VoucherNumber]                        NVARCHAR (200)  NULL,
    [VoucherDate]                          DATETIME        NULL,
    [B2BPaymentMode]                       INT             NULL,
    [DisplayDiscountRate]                  NVARCHAR (500)  NULL,
    [CancellationDeadLine]                 NVARCHAR (500)  NULL,
    [MainAgentID]                          BIGINT          NULL,
    [ISDCode]                              VARCHAR (50)    NULL,
    [AgentRemark]                          NVARCHAR (500)  NULL,
    [SpecialRemark]                        NVARCHAR (MAX)  NULL,
    [PolicyCode]                           VARCHAR (50)    NULL,
    [SB_ReversalStatus]                    BIT             CONSTRAINT [DF_Hotel_BookMaster_SB_ReversalStatus] DEFAULT ((0)) NULL,
    [AgentInvoiceNumber]                   VARCHAR (50)    NULL,
    [InquiryNo]                            VARCHAR (50)    NULL,
    [FileNo]                               VARCHAR (50)    NULL,
    [PaymentRefNo]                         VARCHAR (50)    NULL,
    [OBTCNo]                               VARCHAR (50)    NULL,
    [RTTRefNo]                             VARCHAR (50)    NULL,
    [OpsRemark]                            VARCHAR (50)    NULL,
    [AcctsRemark]                          VARCHAR (50)    NULL,
    [MarkupAmount]                         DECIMAL (10, 2) NULL,
    [MarkupCurrency]                       VARCHAR (50)    NULL,
    [BranchCode]                           NVARCHAR (200)  NULL,
    [BookingCountry]                       VARCHAR (50)    NULL,
    [BookingCountryPkid]                   INT             NULL,
    [Meal]                                 NVARCHAR (500)  NULL,
    [QutechHotelId]                        NVARCHAR (500)  NULL,
    [QutechSearchUniqueId]                 NVARCHAR (500)  NULL,
    [QutechSectionUniqueId]                NVARCHAR (500)  NULL,
    [SupplierUsername]                     NVARCHAR (500)  NULL,
    [SupplierPassword]                     NVARCHAR (500)  NULL,
    [MakePaymentReversalFlag]              VARCHAR (50)    NULL,
    [MakePaymentReversalStatus]            VARCHAR (50)    NULL,
    [MakePaymentReversalMessage]           VARCHAR (MAX)   NULL,
    [AdOn_CancellationCharges]             NVARCHAR (100)  NULL,
    [LocalHotelId]                         NVARCHAR (500)  NULL,
    [BookStatusSchedulerFlag]              BIT             NULL,
    [failurereason]                        VARCHAR (MAX)   NULL,
    [CurrentDateSchedular]                 VARCHAR (200)   NULL,
    [TotalRoomAmount]                      VARCHAR (50)    NULL,
    [TotalSummaryAmount]                   VARCHAR (50)    NULL,
    [AmountBeforePgCommission]             VARCHAR (50)    NULL,
    [AmountAfterPgCommision]               VARCHAR (50)    NULL,
    [PriceChangeOrderId]                   VARCHAR (50)    NULL,
    [ispricechange]                        VARCHAR (5)     NULL,
    [VendorBasicAmount]                    VARCHAR (10)    NULL,
    [VendorBasicAmountBaseCur]             VARCHAR (20)    NULL,
    [ExpectedPriceBaseCur]                 VARCHAR (20)    NULL,
    [RatePerNight]                         VARCHAR (20)    NULL,
    [Hotel_ERPResponceID]                  VARCHAR (500)   NULL,
    [Hotel_CanERPResponceID]               VARCHAR (500)   NULL,
    [Hotel_ERPPushStatus]                  BIT             CONSTRAINT [DF__Hotel_Boo__Hotel__7F035CAB] DEFAULT ((0)) NULL,
    [Hotel_CanERPPushStatus]               BIT             CONSTRAINT [DF__Hotel_Boo__Hotel__7FF780E4] DEFAULT ((0)) NULL,
    [SuBMainAgentID]                       BIGINT          NULL,
    [AlertEmail]                           VARCHAR (200)   NULL,
    [AgentTotalNetAmoun]                   VARCHAR (20)    NULL,
    [RepriceId]                            VARCHAR (50)    NULL,
    [Isi2space]                            INT             NULL,
    [Refundable]                           BIT             NULL,
    [SubAgentId]                           INT             NULL,
    [UserIpAddrress]                       VARCHAR (50)    NULL,
    [providerConfirmationNumber]           VARCHAR (200)   NULL,
    [cancellationToken]                    VARCHAR (200)   NULL,
    [IsGSTRequired]                        VARCHAR (50)    NULL,
    [IsPANCardRequired]                    VARCHAR (50)    NULL,
    [LeaderMiddleName]                     VARCHAR (150)   NULL,
    [CheckInTime]                          VARCHAR (50)    NULL,
    [CheckOutTime]                         VARCHAR (50)    NULL,
    [PayAtHotel]                           BIT             NULL,
    [HotelTaxes]                           DECIMAL (18, 2) NULL,
    [HotelTotalGross]                      DECIMAL (18, 2) NULL,
    [AgentCommission]                      DECIMAL (18, 2) NULL,
    [HotelTDS]                             DECIMAL (18, 2) NULL,
    [BookingPortal]                        VARCHAR (50)    CONSTRAINT [DF_Hotel_BookMaster_PortalBooking] DEFAULT ('Qtech') NOT NULL,
    [ChannelId]                            VARCHAR (100)   NULL,
    [AccountId]                            VARCHAR (100)   NULL,
    [PGStatus]                             VARCHAR (100)   NULL,
    [PaybleAmountOld]                      DECIMAL (18, 2) NULL,
    [SupplierBookingUrl]                   VARCHAR (MAX)   NULL,
    [SupplierBookingPaymentDate]           VARCHAR (100)   NULL,
    [SupplierPkId]                         BIGINT          NULL,
    [Post_addCancellationCharges]          VARCHAR (50)    NULL,
    [Post_addCancellationRemarks]          VARCHAR (500)   NULL,
    [GstOnServiceCharges]                  DECIMAL (18, 2) NULL,
    [ServiceCharges]                       DECIMAL (18, 2) NULL,
    [TotalServiceCharges]                  DECIMAL (18, 2) NULL,
    [GstAmountOnServiceChagres]            DECIMAL (18, 2) NULL,
    [ReconStatus]                          VARCHAR (1)     NULL,
    [ReconDate]                            DATETIME        NULL,
    [ReconBy]                              INT             NULL,
    [ReconRemark]                          VARCHAR (MAX)   NULL,
    [FinalROE]                             DECIMAL (18, 5) NULL,
    [Lat]                                  DECIMAL (18, 8) NULL,
    [Lang]                                 DECIMAL (18, 8) NULL,
    [Nationalty]                           VARCHAR (100)   NULL,
    [SPublishedBaseRate]                   DECIMAL (18, 2) NULL,
    [SPublishedRate]                       DECIMAL (18, 2) NULL,
    [STotalRate]                           DECIMAL (18, 2) NULL,
    [SBaseRate]                            DECIMAL (18, 2) NULL,
    [SComission]                           DECIMAL (18, 2) NULL,
    [SCurrency]                            VARCHAR (50)    NULL,
    [IsApiOutBooking]                      BIT             NULL,
    [RequestForCancelled]                  VARCHAR (50)    NULL,
    [SupplierChargesPer]                   DECIMAL (18, 2) NULL,
    [SupplierCharges]                      DECIMAL (18, 6) NULL,
    [VccPer]                               DECIMAL (18, 2) NULL,
    [VccValue]                             DECIMAL (18, 4) NULL,
    [SupplierCommitionLocal]               DECIMAL (18, 2) NULL,
    [SINRCommissionAmount]                 DECIMAL (18, 4) NULL,
    [SCommissionDiscription]               VARCHAR (500)   NULL,
    [agentCancellationCharges]             DECIMAL (18, 2) NULL,
    [SupplierCancellationCharges]          DECIMAL (18, 2) NULL,
    [HotelIncludes]                        VARCHAR (500)   NULL,
    [SupplierINRROEValue]                  DECIMAL (18, 6) NULL,
    [ClientBookingId]                      VARCHAR (200)   NULL,
    [MembershipNumber]                     VARCHAR (50)    NULL,
    [ChainName]                            VARCHAR (150)   NULL,
    [CustomerId]                           VARCHAR (200)   NULL,
    [PanCardURL]                           VARCHAR (500)   NULL,
    [PayHotelPaymentStatus]                BIT             CONSTRAINT [DF_Hotel_BookMaster_PayHotelPaymentStatus] DEFAULT ((0)) NULL,
    [BKCancellation]                       DATETIME        NULL,
    [CancelledBy]                          INT             NULL,
    [ModeOfCancellation]                   VARCHAR (20)    NULL,
    [CancellationDate]                     DATETIME        NULL,
    [PaymentStatus]                        VARCHAR (200)   NULL,
    [PaymentRemark]                        VARCHAR (200)   NULL,
    [PNRofficeId]                          VARCHAR (20)    NULL,
    [PNRRateType]                          VARCHAR (100)   NULL,
    [FreeTextPNRInclusion]                 VARCHAR (300)   NULL,
    [FreeTextPNRRoomCategory]              VARCHAR (300)   NULL,
    [AgentServiceFee]                      DECIMAL (18, 2) NULL,
    [AgentServiceFeeRealTime]              DECIMAL (18, 2) NULL,
    [DestinationCountryCode]               VARCHAR (100)   NULL,
    [TdsDeductedAfterCancel]               DECIMAL (18, 2) NULL,
    [ServiceTimeVerified]                  BIT             NULL,
    [ServiceTimeVerifiedBy]                INT             NULL,
    [ModifiedCheckInTime]                  VARCHAR (20)    NULL,
    [ModifiedCheckOutTime]                 VARCHAR (20)    NULL,
    [ServiceTimeModified]                  BIT             NULL,
    [ServiceTimeModifiedBy]                INT             NULL,
    [CorporatePANVerificatioStatus]        VARCHAR (100)   NULL,
    [DispositionStatus]                    VARCHAR (200)   NULL,
    [ResolutionStatus]                     VARCHAR (200)   NULL,
    [CorporatePanReq]                      VARCHAR (10)    NULL,
    [BookingRateType]                      VARCHAR (100)   NULL,
    [HotelPostalCode]                      VARCHAR (100)   NULL,
    [HotelBookStateName]                   VARCHAR (100)   NULL,
    [HotelBookCountryName]                 VARCHAR (100)   NULL,
    [HotelBookCountryCode]                 VARCHAR (100)   NULL,
    [PassengerConfirmation]                VARCHAR (10)    NULL,
    [MealPlanConfirmation]                 VARCHAR (10)    NULL,
    [RoomTypeConfirmation]                 VARCHAR (10)    NULL,
    [ExtrabedConfirmation]                 VARCHAR (10)    NULL,
    [PaymentConfirmation]                  VARCHAR (10)    NULL,
    [ConfByEmailConfirmation]              VARCHAR (10)    NULL,
    [PassengerDetailsReconfirmationRemark] NVARCHAR (500)  NULL,
    [PassengerDetailsReconfirmationBy]     INT             NULL,
    [OldOBTCNo]                            VARCHAR (50)    NULL,
    [HotelAdditionalInformation]           VARCHAR (MAX)   NULL,
    [MBPageOBTCNo]                         VARCHAR (50)    NULL,
    [RiyaUserRealTimeServiceFee]           DECIMAL (18, 2) NULL,
    [GSTOnRiyaUsereRealTimeServiceFee]     DECIMAL (18, 2) NULL,
    [winyatraError]                        VARCHAR (MAX)   NULL,
    [winyatraInvoice]                      VARCHAR (50)    NULL,
    [HotelDiscount]                        DECIMAL (18, 2) NULL,
    [ERP_PayToVendor]                      VARCHAR (30)    NULL,
    [HotelInformation]                     VARCHAR (MAX)   NULL,
    [SupplierCheckInDate]                  DATETIME        NULL,
    [SupplierCheckOutDate]                 DATETIME        NULL,
    [ReconCounter]                         INT             CONSTRAINT [DF_Hotel_BookMaster_ReconCounter] DEFAULT ((0)) NULL,
    [ClientIP]                             VARCHAR (100)   NULL,
    [LoginSessionId]                       VARCHAR (600)   NULL,
    [AUTOHCNEMAILSENT]                     BIT             NULL,
    [DespositionStatus]                    VARCHAR (200)   NULL,
    [ServiceChargesPercent]                DECIMAL (18, 2) NULL,
    [HotelEmails]                          VARCHAR (1000)  NULL,
    [HotelFax]                             VARCHAR (100)   NULL,
    [HotelOffsetGMT]                       VARCHAR (50)    NULL,
    [BookingSearchType]                    VARCHAR (100)   NULL,
    CONSTRAINT [PK_Hotel_BookMaster] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_BookingReference]
    ON [dbo].[Hotel_BookMaster]([BookingReference] ASC) WHERE ([BookingReference] IS NOT NULL);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-B2bPaymentMode]
    ON [dbo].[Hotel_BookMaster]([B2BPaymentMode] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_unq_orderId]
    ON [dbo].[Hotel_BookMaster]([orderId] ASC) WHERE ([orderId] IS NOT NULL);


GO
CREATE NONCLUSTERED INDEX [Noncluster_testIndex]
    ON [dbo].[Hotel_BookMaster]([B2BPaymentMode] ASC)
    INCLUDE([pkId], [orderId], [BookingReference], [riyaPNR], [LeaderTitle], [LeaderFirstName], [LeaderLastName], [CurrencyCode], [HotelName], [CountryName], [ExpirationDate], [CheckInDate], [CheckOutDate], [AgentRefNo], [inserteddate], [cityName], [CancelDate], [SupplierReferenceNo], [HotelConfNumber], [RiyaAgentID], [VoucherNumber], [VoucherDate], [DisplayDiscountRate], [CancellationDeadLine], [MainAgentID], [OBTCNo], [CheckInTime], [PayAtHotel], [SupplierPkId], [RequestForCancelled], [agentCancellationCharges]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-MainAgentID]
    ON [dbo].[Hotel_BookMaster]([MainAgentID] ASC);


GO
CREATE NONCLUSTERED INDEX [Nonclustere_compositeIndex]
    ON [dbo].[Hotel_BookMaster]([BookingReference] ASC, [RiyaAgentID] ASC)
    INCLUDE([orderId], [riyaPNR], [LeaderTitle], [LeaderFirstName], [LeaderLastName], [HotelName], [HotelAddress1], [CheckInDate], [CheckOutDate], [BranchCode], [BookingCountry], [providerConfirmationNumber], [Post_addCancellationRemarks], [ModeOfCancellation]);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_compositeIndex_400]
    ON [dbo].[Hotel_BookMaster]([B2BPaymentMode] ASC)
    INCLUDE([orderId], [BookingReference], [riyaPNR], [LeaderTitle], [LeaderFirstName], [LeaderLastName], [CurrencyCode], [HotelName], [CountryName], [ExpirationDate], [CheckInDate], [CheckOutDate], [AgentRefNo], [inserteddate], [cityName], [CancelDate], [SupplierReferenceNo], [HotelConfNumber], [RiyaAgentID], [VoucherNumber], [VoucherDate], [DisplayDiscountRate], [CancellationDeadLine], [MainAgentID], [OBTCNo], [SuBMainAgentID], [providerConfirmationNumber], [CheckInTime], [PayAtHotel], [SupplierPkId], [ReconStatus], [agentCancellationCharges], [ModifiedCheckInTime], [ServiceTimeModified], [PassengerDetailsReconfirmationRemark]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_index_500]
    ON [dbo].[Hotel_BookMaster]([BookingReference] ASC, [B2BPaymentMode] ASC)
    INCLUDE([orderId], [riyaPNR], [LeaderTitle], [LeaderFirstName], [LeaderLastName], [CurrencyCode], [HotelName], [CountryName], [ExpirationDate], [CheckInDate], [CheckOutDate], [AgentRefNo], [inserteddate], [cityName], [CancelDate], [SupplierName], [SupplierReferenceNo], [HotelConfNumber], [RiyaAgentID], [VoucherNumber], [VoucherDate], [DisplayDiscountRate], [CancellationDeadLine], [MainAgentID], [OBTCNo], [SuBMainAgentID], [providerConfirmationNumber], [CheckInTime], [PayAtHotel], [SupplierPkId], [ReconStatus], [agentCancellationCharges], [ModifiedCheckInTime], [ServiceTimeModified], [PassengerDetailsReconfirmationRemark]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_composite_Index_2]
    ON [dbo].[Hotel_BookMaster]([RiyaAgentID] ASC, [BookingPortal] ASC)
    INCLUDE([orderId], [BookingReference], [MainAgentID], [AgentCommission], [pkId]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX22]
    ON [dbo].[Hotel_BookMaster]([BookingPortal] ASC)
    INCLUDE([inserteddate], [SupplierName], [DisplayDiscountRate], [FinalROE]);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create TRIGGER [dbo].[AddSequnce] 
   ON  dbo.Hotel_BookMaster 
   AFTER insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Update Hotel.[Hotel_orders_sequence] set Sequence_no=Sequence_no+1 where id=1

END
