CREATE TABLE [dbo].[EventDetails] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EventName]      VARCHAR (300) NULL,
    [EventStartDate] DATETIME      NULL,
    [EventEndDate]   DATETIME      NULL,
    [City]           VARCHAR (150) NULL,
    [OtherInfo]      VARCHAR (300) NULL,
    [CreatedBy]      INT           NULL,
    [CreatedDate]    DATETIME      NULL,
    [UpdatedBy]      INT           NULL,
    [UpdatedDate]    DATETIME      NULL,
    [EventStatus]    BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

