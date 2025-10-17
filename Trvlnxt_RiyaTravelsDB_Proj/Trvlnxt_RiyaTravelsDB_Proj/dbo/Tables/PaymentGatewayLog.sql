CREATE TABLE [dbo].[PaymentGatewayLog] (
    [pkid]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderID]      VARCHAR (30)  NULL,
    [Request]      VARCHAR (MAX) NULL,
    [Response]     VARCHAR (MAX) NULL,
    [RequestDate]  DATETIME      CONSTRAINT [DF_PaymentGatwayLog_InsertedDate] DEFAULT (getdate()) NULL,
    [ResponseDate] DATETIME      NULL,
    [Country]      VARCHAR (2)   NULL,
    CONSTRAINT [PK_PaymentGatwayLog] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

