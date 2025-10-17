CREATE TABLE [dbo].[Paymentmaster] (
    [PKID]                     BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [order_id]                 VARCHAR (255) NULL,
    [tracking_id]              VARCHAR (50)  NULL,
    [bank_ref_no]              VARCHAR (MAX) NULL,
    [order_status]             VARCHAR (30)  NULL,
    [failure_message]          VARCHAR (MAX) NULL,
    [payment_mode]             VARCHAR (250) NULL,
    [card_name]                VARCHAR (MAX) NULL,
    [status_code]              VARCHAR (10)  NULL,
    [status_message]           VARCHAR (150) NULL,
    [currency]                 CHAR (3)      NULL,
    [amount]                   VARCHAR (30)  NULL,
    [billing_name]             VARCHAR (60)  NULL,
    [billing_address]          VARCHAR (150) NULL,
    [billing_city]             VARCHAR (30)  NULL,
    [billing_state]            VARCHAR (30)  NULL,
    [billing_zip]              VARCHAR (15)  NULL,
    [billing_country]          VARCHAR (50)  NULL,
    [billing_tel]              VARCHAR (20)  NULL,
    [billing_email]            VARCHAR (70)  NULL,
    [vault]                    CHAR (1)      NULL,
    [offer_type]               VARCHAR (9)   NULL,
    [offer_code]               VARCHAR (30)  NULL,
    [discount_value]           VARCHAR (30)  NULL,
    [mer_amount]               VARCHAR (30)  NULL,
    [eci_value]                VARCHAR (30)  NULL,
    [retry]                    CHAR (1)      NULL,
    [response_code]            VARCHAR (30)  NULL,
    [inserteddt]               DATETIME      CONSTRAINT [DF_Paymentmaster_inserteddt] DEFAULT (getdate()) NULL,
    [riyaPNR]                  VARCHAR (20)  NULL,
    [billing_notes]            VARCHAR (MAX) NULL,
    [getway_name]              VARCHAR (50)  NULL,
    [OriginalStatus]           VARCHAR (500) NULL,
    [CardNumber]               VARCHAR (50)  NULL,
    [ExpiryDate]               VARCHAR (50)  NULL,
    [CVV]                      VARCHAR (50)  NULL,
    [CardType]                 VARCHAR (50)  NULL,
    [Country]                  VARCHAR (50)  NULL,
    [PaymentGateway]           VARCHAR (50)  NULL,
    [Type]                     VARCHAR (20)  NULL,
    [ERPKey]                   NVARCHAR (50) NULL,
    [InterchangeValue]         VARCHAR (20)  NULL,
    [TDR]                      VARCHAR (50)  NULL,
    [PaymentMode]              VARCHAR (50)  NULL,
    [SubMerchantId]            VARCHAR (50)  NULL,
    [TPS]                      VARCHAR (50)  NULL,
    [RSV]                      VARCHAR (50)  NULL,
    [CardID]                   INT           NULL,
    [IsHold]                   BIT           NULL,
    [EnCardNumber]             VARCHAR (MAX) NULL,
    [EnExpiryDate]             VARCHAR (MAX) NULL,
    [EnCVV]                    VARCHAR (MAX) NULL,
    [MaskCardNumber]           VARCHAR (50)  NULL,
    [AuthCode]                 VARCHAR (50)  NULL,
    [payment_gatewaymode]      VARCHAR (50)  NULL,
    [MerchantId]               VARCHAR (50)  NULL,
    [BankAccountNo]            VARCHAR (50)  NULL,
    [ParentOrderId]            VARCHAR (50)  NULL,
    [AirlinePaymentCardNumber] VARCHAR (50)  NULL,
    [AirlinePaymentCardType]   VARCHAR (50)  NULL,
    [AirlinePaymentCardOwner]  VARCHAR (50)  NULL,
    [AmendmentRefNo]           VARCHAR (50)  NULL,
    [Source]                   VARCHAR (50)  NULL,
    [CardConfigurationType]    VARCHAR (50)  NULL,
    [TransactionType]          VARCHAR (50)  NULL,
    CONSTRAINT [PK_Paymentmaster] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Noncluster_compositeIndex]
    ON [dbo].[Paymentmaster]([amount] ASC)
    INCLUDE([order_id], [payment_mode]);


GO
CREATE NONCLUSTERED INDEX [Paymentmaster_payment_mode]
    ON [dbo].[Paymentmaster]([payment_mode] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_order_id]
    ON [dbo].[Paymentmaster]([order_id] ASC);


GO
CREATE NONCLUSTERED INDEX [Noncluster_Index_ParentOrderId]
    ON [dbo].[Paymentmaster]([ParentOrderId] ASC);

