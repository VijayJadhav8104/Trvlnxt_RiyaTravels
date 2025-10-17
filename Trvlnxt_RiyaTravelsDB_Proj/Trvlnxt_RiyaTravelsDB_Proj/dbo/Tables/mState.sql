CREATE TABLE [dbo].[mState] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [StateName]    VARCHAR (100) NULL,
    [InsertedDate] DATETIME      NULL,
    [status]       BIT           NULL,
    [StateCode]    VARCHAR (2)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

