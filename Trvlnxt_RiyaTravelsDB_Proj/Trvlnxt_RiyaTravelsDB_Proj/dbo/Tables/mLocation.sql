CREATE TABLE [dbo].[mLocation] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LocationName] VARCHAR (100) NULL,
    [LocationCode] VARCHAR (10)  NULL,
    [Status]       BIT           CONSTRAINT [DF_mLocation_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_mLocation] PRIMARY KEY CLUSTERED ([ID] ASC)
);

