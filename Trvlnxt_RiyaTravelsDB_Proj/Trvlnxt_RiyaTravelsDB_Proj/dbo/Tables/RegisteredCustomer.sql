CREATE TABLE [dbo].[RegisteredCustomer] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EventID]        INT           NULL,
    [CustomerName]   VARCHAR (300) NULL,
    [Email]          VARCHAR (150) NULL,
    [Mobile]         BIGINT        NULL,
    [City]           VARCHAR (150) NULL,
    [OtherInfo]      VARCHAR (300) NULL,
    [RegisteredDate] DATETIME      NULL,
    [CreatedBy]      INT           NULL,
    [CreatedDate]    DATETIME      NULL,
    [UpdatedBy]      INT           NULL,
    [UpdatedDate]    DATETIME      NULL,
    [CustomerStatus] BIT           NULL
);

