CREATE TABLE [dbo].[temp_indigo_pnr] (
    [id]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [pnr]      VARCHAR (100) NULL,
    [officeid] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

