CREATE TABLE [dbo].[AgentTopupPaymentGatewayLog] (
    [PaymentGatewayLogIDP] BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]               INT           NULL,
    [TransactionID]        VARCHAR (50)  NULL,
    [RequestLog]           VARCHAR (MAX) NULL,
    [ResponseLog]          VARCHAR (MAX) NULL,
    [RequestDate]          DATETIME      NULL,
    [ResponseDate]         DATETIME      NULL,
    CONSTRAINT [PK_AgentTopupPaymentGatewayLog] PRIMARY KEY CLUSTERED ([PaymentGatewayLogIDP] ASC)
);

