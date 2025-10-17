CREATE TABLE [dbo].[mastProductClass] (
    [ID]                INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirLine]           VARCHAR (50) NULL,
    [ProductClassValue] VARCHAR (10) NULL,
    [ProductClass]      VARCHAR (50) NULL,
    CONSTRAINT [PK_mastProductClass] PRIMARY KEY CLUSTERED ([ID] ASC)
);

