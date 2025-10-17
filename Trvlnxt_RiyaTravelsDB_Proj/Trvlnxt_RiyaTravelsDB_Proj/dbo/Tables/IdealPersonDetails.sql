CREATE TABLE [dbo].[IdealPersonDetails] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FullName]     VARCHAR (100) NOT NULL,
    [ContactNum]   NUMERIC (15)  NOT NULL,
    [EmailID]      VARCHAR (50)  NOT NULL,
    [IP]           VARCHAR (50)  NULL,
    [Browser]      VARCHAR (50)  NULL,
    [Country]      VARCHAR (50)  NULL,
    [InsertedDate] DATETIME      NULL,
    [Device]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_IdealPersonDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);

