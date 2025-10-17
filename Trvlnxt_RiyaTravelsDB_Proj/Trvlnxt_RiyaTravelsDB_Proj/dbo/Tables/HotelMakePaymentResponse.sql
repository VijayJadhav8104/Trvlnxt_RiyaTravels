CREATE TABLE [dbo].[HotelMakePaymentResponse] (
    [ID]                INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Orderid]           VARCHAR (200) NULL,
    [Status]            VARCHAR (50)  NULL,
    [EncriptDecripCode] VARCHAR (500) NULL,
    [TxnID]             VARCHAR (200) NULL,
    [FailureMsg]        VARCHAR (500) NULL,
    CONSTRAINT [PK_HotelMakePaymentResponse] PRIMARY KEY CLUSTERED ([ID] ASC)
);

