CREATE TABLE [dbo].[tblPassengerBookDetails] (
    [pid]                        BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkBookMaster]               BIGINT          NULL,
    [paxType]                    VARCHAR (50)    NULL,
    [paxFName]                   VARCHAR (50)    NULL,
    [paxLName]                   VARCHAR (50)    NULL,
    [passportNum]                VARCHAR (30)    NULL,
    [passportIssueCountry]       VARCHAR (100)   NULL,
    [passexp]                    DATE            NULL,
    [inserteddate]               DATETIME        CONSTRAINT [DF_tblPassengerBookDetails_inserteddate] DEFAULT (getdate()) NULL,
    [status]                     BIT             CONSTRAINT [DF_tblPassengerBookDetails_status] DEFAULT ((0)) NULL,
    [title]                      VARCHAR (10)    NULL,
    [dateOfBirth]                DATETIME        NULL,
    [nationality]                VARCHAR (50)    CONSTRAINT [DF_tblPassengerBookDetails_nationality] DEFAULT ('India') NULL,
    [gender]                     VARCHAR (20)    NULL,
    [ticketNum]                  VARCHAR (200)   NULL,
    [Isrescheduled]              BIT             NULL,
    [Iscancelled]                BIT             CONSTRAINT [DF_tblPassengerBookDetails_Iscancelled] DEFAULT ((0)) NULL,
    [YQ]                         VARCHAR (50)    CONSTRAINT [DF_tblPassengerBookDetails_YQ] DEFAULT ('0') NULL,
    [TDSamount]                  INT             NULL,
    [serviceCharge]              INT             NULL,
    [managementfees]             INT             NULL,
    [airlineCancellationPanelty] VARCHAR (500)   NULL,
    [riyaCancellationCharges]    INT             NULL,
    [RemainingRefund]            INT             NULL,
    [RefundAmount]               INT             NULL,
    [IsRefunded]                 BIT             CONSTRAINT [DF_tblPassengerBookDetails_IsRefunded] DEFAULT ((0)) NULL,
    [RefundedDate]               DATETIME        NULL,
    [reScheduleCharge]           INT             NULL,
    [airPNR]                     VARCHAR (50)    NULL,
    [cancellationRemark]         VARCHAR (500)   NULL,
    [fflyer]                     VARCHAR (100)   NULL,
    [baggage]                    VARCHAR (100)   NULL,
    [totalFare]                  DECIMAL (18, 2) NULL,
    [basicFare]                  DECIMAL (18, 2) NULL,
    [totalTax]                   DECIMAL (18, 2) NULL,
    [isReturn]                   BIT             CONSTRAINT [DF_tblPassengerBookDetails_isReturn] DEFAULT ((0)) NULL,
    [Discount]                   INT             NULL,
    [FlatDiscount]               INT             NULL,
    [GovtTax]                    INT             NULL,
    [CancellationCharge]         INT             NULL,
    [Panelty]                    DECIMAL (18)    NULL,
    [YRTax]                      DECIMAL (18, 2) NULL,
    [INTax]                      DECIMAL (18, 2) NULL,
    [JNTax]                      DECIMAL (18, 2) NULL,
    [OCTax]                      DECIMAL (18, 2) NULL,
    [ExtraTax]                   DECIMAL (18, 2) NULL,
    [DiscriptionTax]             VARCHAR (1000)  NULL,
    [isProcessRefund]            BIT             CONSTRAINT [DF_tblPassengerBookDetails_isProcessRefund] DEFAULT ((0)) NULL,
    [CancelledDate]              DATETIME        NULL,
    [CommissionType]             INT             NULL,
    [ServiceChargeType]          INT             NULL,
    [FlatDiscountType]           INT             NULL,
    [CancellationChargeType]     INT             NULL,
    [IATACommission]             DECIMAL (18, 2) NULL,
    [PLBCommission]              DECIMAL (18, 2) NULL,
    [GovtTaxPercent]             DECIMAL (18, 2) NULL,
    [IATAPercent]                DECIMAL (18, 2) NULL,
    [PLBPercent]                 DECIMAL (18, 2) NULL,
    [IsIATAOnBasic]              BIT             NULL,
    [IsPLBOnBasic]               BIT             NULL,
    [CancelClosed]               BIT             CONSTRAINT [DF_tblPassengerBookDetails_CancelClosed] DEFAULT ((0)) NULL,
    [Markup]                     DECIMAL (18, 2) CONSTRAINT [DF_tblPassengerBookDetails_Markup] DEFAULT ((0)) NULL,
    [ERPKey]                     NVARCHAR (50)   NULL,
    [FailedFlag]                 INT             NULL,
    [PassIssue]                  DATE            NULL,
    [ERPResponseID]              VARCHAR (200)   NULL,
    [FMCommission]               DECIMAL (18, 2) NULL,
    [CancERPResponseID]          VARCHAR (200)   NULL,
    [ERPPuststatus]              BIT             NULL,
    [TicketNumber]               VARCHAR (50)    NULL,
    [DropnetCommission]          DECIMAL (18, 2) NULL,
    [MCOAmount]                  DECIMAL (18, 2) NULL,
    [ServiceFee]                 DECIMAL (18, 2) NULL,
    [GST]                        DECIMAL (18, 2) NULL,
    [B2bMarkup]                  DECIMAL (18, 4) CONSTRAINT [DF_tblPassengerBookDetails_B2bMarkup] DEFAULT ((0)) NULL,
    [MCOTicketNo]                VARCHAR (50)    NULL,
    [BFC]                        INT             NULL,
    [BookingStatus]              INT             NULL,
    [RemarkCancellation]         NVARCHAR (500)  NULL,
    [RemarkCancellation2]        NVARCHAR (500)  NULL,
    [CancellationPenalty]        DECIMAL (18, 2) NULL,
    [CancellationMarkup]         DECIMAL (18, 2) NULL,
    [cancellationDate]           DATETIME        NULL,
    [RemarkCancellation3]        NVARCHAR (500)  NULL,
    [Debit]                      DECIMAL (18, 2) NULL,
    [TobecancellationDate]       DATETIME        NULL,
    [CancelByAgency]             INT             NULL,
    [CancelByBackendUser]        INT             NULL,
    [Profession]                 VARCHAR (100)   NULL,
    [CancelByBackendUser1]       INT             NULL,
    [CancelByAgency1]            INT             NULL,
    [CheckboxVoid]               BIT             NULL,
    [CancERPPuststatus]          BIT             NULL,
    [IsCreditNoteGen]            BIT             CONSTRAINT [DF_tblPassengerBookDetails_IsCreditNoteGen] DEFAULT ((0)) NULL,
    [SupplierPenalty]            DECIMAL (18)    NULL,
    [RescheduleMarkup]           DECIMAL (18)    NULL,
    [RescheduleDate]             DATETIME        NULL,
    [RescheduleRemarks]          NVARCHAR (500)  NULL,
    [CDCNumber]                  VARCHAR (40)    NULL,
    [BaggageFare]                DECIMAL (18)    NULL,
    [isTicketPaymentB2CPushed]   BIT             NULL,
    [YMTax]                      DECIMAL (18, 2) NULL,
    [WOTax]                      DECIMAL (18, 2) NULL,
    [OBTax]                      DECIMAL (18, 2) NULL,
    [RFTax]                      DECIMAL (18, 2) NULL,
    [ERPMcoResponseID]           VARCHAR (200)   NULL,
    [ERPMcoPushStatus]           BIT             NULL,
    [CannERPMcoResponseID]       VARCHAR (200)   NULL,
    [CannERPMcoPushStatus]       BIT             NULL,
    [HupAmount]                  DECIMAL (18, 2) NULL,
    [MCOMerchantfee]             DECIMAL (18, 3) NULL,
    [CabinBaggage]               VARCHAR (MAX)   NULL,
    [FrequentFlyNo]              VARCHAR (100)   NULL,
    [MarkupOnTaxFare]            DECIMAL (18, 2) NULL,
    [MarkuponPenalty]            DECIMAL (18, 2) NULL,
    [CancellationServiceFee]     DECIMAL (18, 2) NULL,
    [OpenTicketDate]             DATETIME        NULL,
    [ReverseByMainAgentId]       INT             NULL,
    [BarCode]                    VARCHAR (MAX)   NULL,
    [PassengerID]                NVARCHAR (50)   NULL,
    [WinYatraInvoice]            VARCHAR (100)   NULL,
    [DiscountTDS]                DECIMAL (18, 2) NULL,
    [DiscountGST]                DECIMAL (18, 2) NULL,
    [VendorServiceFee]           DECIMAL (18, 2) NULL,
    [TDSonIATA]                  DECIMAL (18, 2) NULL,
    [GSTonPLB]                   DECIMAL (18, 2) NULL,
    [TDSonPLB]                   DECIMAL (18, 2) NULL,
    [PanNumber]                  VARCHAR (20)    NULL,
    [PanCardValidation]          VARCHAR (100)   NULL,
    [MarkOn]                     VARCHAR (20)    NULL,
    [LonServiceFee]              DECIMAL (18, 2) NULL,
    [K7Tax]                      DECIMAL (18, 4) NULL,
    [AirlineFee]                 DECIMAL (18, 4) NULL,
    [AirlineGST]                 DECIMAL (18, 4) NULL,
    [EMDNumber]                  VARCHAR (50)    NULL,
    [OPID]                       INT             NULL,
    [EMDstatus]                  INT             DEFAULT ((0)) NULL,
    [EMDAirLineCode]             VARCHAR (50)    NULL,
    [ParentB2BMarkup]            VARCHAR (10)    NULL,
    [NameAsOnPAN]                VARCHAR (100)   NULL,
    CONSTRAINT [PK_tblPassengerBookDetails] PRIMARY KEY CLUSTERED ([pid] ASC),
    CONSTRAINT [FK_tblPassengerBookDetails_tblPassengerBookDetails1] FOREIGN KEY ([pid]) REFERENCES [dbo].[tblPassengerBookDetails] ([pid])
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-BookingStatus]
    ON [dbo].[tblPassengerBookDetails]([BookingStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-fkBookMaster]
    ON [dbo].[tblPassengerBookDetails]([fkBookMaster] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-composite_Index_2]
    ON [dbo].[tblPassengerBookDetails]([pid] ASC, [fkBookMaster] ASC, [paxFName] ASC, [paxLName] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-paxFName]
    ON [dbo].[tblPassengerBookDetails]([paxFName] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-paxLName]
    ON [dbo].[tblPassengerBookDetails]([paxLName] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-paxType]
    ON [dbo].[tblPassengerBookDetails]([paxType] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Ticketnum]
    ON [dbo].[tblPassengerBookDetails]([ticketNum] ASC);

