CREATE TABLE [dbo].[PassThroughMaster] (
    [Id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineName] VARCHAR (200)  NULL,
    [Percentage]  NVARCHAR (MAX) NULL,
    [FairType]    VARCHAR (800)  NULL,
    [CreatedDate] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

