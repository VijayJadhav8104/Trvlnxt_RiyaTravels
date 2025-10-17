CREATE TABLE [dbo].[ServiceCharges] (
    [PKId]              BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SectorType]        VARCHAR (5)  NULL,
    [AirCode]           VARCHAR (20) NULL,
    [amount]            INT          NULL,
    [Insert_date]       DATE         NULL,
    [UserId]            INT          NULL,
    [ModifiedDate]      DATE         NULL,
    [IsActive]          BIT          CONSTRAINT [ServiceCharges_ISActive] DEFAULT ((1)) NULL,
    [ModifiedBy]        INT          NULL,
    [ServiceChargeType] INT          NULL,
    CONSTRAINT [PK_ServiceCharges] PRIMARY KEY CLUSTERED ([PKId] ASC)
);

