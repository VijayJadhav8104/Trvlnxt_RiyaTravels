CREATE TABLE [dbo].[RBDMappingLog] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [ErrorMsg]      VARCHAR (MAX) NULL,
    [ReqJson]       VARCHAR (MAX) NULL,
    [DealMappingID] INT           NULL,
    [EntryDate]     DATETIME      NULL,
    CONSTRAINT [PK_RBDMappingLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

