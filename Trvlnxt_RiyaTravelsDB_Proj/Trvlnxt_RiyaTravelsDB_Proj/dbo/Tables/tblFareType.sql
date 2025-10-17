CREATE TABLE [dbo].[tblFareType] (
    [ID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FareType] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_tblFareType] PRIMARY KEY CLUSTERED ([ID] ASC)
);

