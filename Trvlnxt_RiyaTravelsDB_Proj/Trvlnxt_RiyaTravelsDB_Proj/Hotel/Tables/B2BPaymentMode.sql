CREATE TABLE [Hotel].[B2BPaymentMode] (
    [Pkid]            INT           IDENTITY (1, 1) NOT NULL,
    [PaymentModeId]   INT           NULL,
    [PaymentType]     VARCHAR (600) NULL,
    [PaymentHtmlText] VARCHAR (600) NULL
);

