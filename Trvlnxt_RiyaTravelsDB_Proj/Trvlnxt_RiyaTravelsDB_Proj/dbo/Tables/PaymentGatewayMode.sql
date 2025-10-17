CREATE TABLE [dbo].[PaymentGatewayMode] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PGID]        INT           NULL,
    [Mode]        VARCHAR (100) NULL,
    [Charges]     FLOAT (53)    NULL,
    [IsActive]    BIT           NULL,
    [CreatedDate] DATE          NULL,
    [Vat]         FLOAT (53)    NULL,
    CONSTRAINT [PK_PaymentGatewayMode] PRIMARY KEY CLUSTERED ([Id] ASC)
);

