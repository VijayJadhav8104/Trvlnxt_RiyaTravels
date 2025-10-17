CREATE TABLE [dbo].[RPGConvenienceFee] (
    [RPGConvenienceFeeIDP] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PaymentGateway]       VARCHAR (50)    NULL,
    [PaymentGatewayMode]   VARCHAR (50)    NULL,
    [ConvenienceFee]       NUMERIC (18, 2) NULL,
    [IsActive]             BIT             CONSTRAINT [DF_RPGConvenienceFee_IsActive] DEFAULT ((1)) NULL,
    [SystemDateTime]       DATETIME        CONSTRAINT [DF_RPGConvenienceFee_SystemDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_RPGConvenienceFee] PRIMARY KEY CLUSTERED ([RPGConvenienceFeeIDP] ASC)
);

