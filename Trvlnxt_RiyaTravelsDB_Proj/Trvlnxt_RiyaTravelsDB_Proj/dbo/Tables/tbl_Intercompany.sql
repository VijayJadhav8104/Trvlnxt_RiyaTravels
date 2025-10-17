CREATE TABLE [dbo].[tbl_Intercompany] (
    [ID]      INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Icust]   VARCHAR (50) NULL,
    [StateID] INT          NULL,
    CONSTRAINT [PK_tbl_Intercompany] PRIMARY KEY CLUSTERED ([ID] ASC)
);

