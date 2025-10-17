CREATE TABLE [dbo].[CacheAPISession] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SessionToken] VARCHAR (300) NULL,
    [SessionData]  VARCHAR (MAX) NULL,
    [InsertedDate] DATETIME2 (7) CONSTRAINT [DF_CacheAPISession_InsertedDate] DEFAULT (getdate()) NULL,
    [UpdatedDate]  DATETIME2 (7) NULL,
    CONSTRAINT [PK_CacheAPISession] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ__CacheAPI__46BDD124A95716EE] UNIQUE NONCLUSTERED ([SessionToken] ASC)
);

