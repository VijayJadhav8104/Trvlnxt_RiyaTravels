CREATE TABLE [dbo].[mProfession] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProfessionName] VARCHAR (100) NULL,
    [ProfessionCode] VARCHAR (20)  NULL,
    CONSTRAINT [PK_mProfession] PRIMARY KEY CLUSTERED ([ID] ASC)
);

