CREATE TABLE [dbo].[testrepl] (
    [id]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name] VARCHAR (50) NULL,
    CONSTRAINT [PK_testrepl] PRIMARY KEY CLUSTERED ([id] ASC)
);

