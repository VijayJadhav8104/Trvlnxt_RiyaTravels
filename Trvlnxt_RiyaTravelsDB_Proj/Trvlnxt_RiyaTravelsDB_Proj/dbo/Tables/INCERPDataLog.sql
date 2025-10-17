CREATE TABLE [dbo].[INCERPDataLog] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkBookMasterId] BIGINT        NOT NULL,
    [Type]           VARCHAR (50)  NULL,
    [Response]       VARCHAR (MAX) NULL,
    [Request]        VARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME      CONSTRAINT [DF_INCERPDataLog_CreatedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_INCERPDataLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

