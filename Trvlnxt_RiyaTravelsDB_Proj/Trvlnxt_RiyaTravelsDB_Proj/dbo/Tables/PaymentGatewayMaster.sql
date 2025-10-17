CREATE TABLE [dbo].[PaymentGatewayMaster] (
    [PG_Id]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]         VARCHAR (100) NULL,
    [MarchantType] VARCHAR (500) NULL,
    [IsActive]     BIT           CONSTRAINT [DF_PaymentGatewayMaster_IsActive] DEFAULT ((1)) NULL,
    [CreatedBy]    INT           NULL,
    [CreatedDate]  DATETIME      CONSTRAINT [DF_PaymentGatewayMaster_CreatedDate] DEFAULT (getdate()) NULL,
    [UpdatedBy]    INT           NULL,
    [UpdatedDate]  DATETIME      NULL,
    CONSTRAINT [PK__PaymentG__5A7A1AADE916A663] PRIMARY KEY CLUSTERED ([PG_Id] ASC)
);

