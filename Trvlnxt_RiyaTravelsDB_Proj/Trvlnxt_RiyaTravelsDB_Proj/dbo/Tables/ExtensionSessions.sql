CREATE TABLE [dbo].[ExtensionSessions] (
    [Id]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfficeId]    VARCHAR (50) NULL,
    [SessionData] TEXT         NULL,
    [LoginId]     VARCHAR (50) NULL,
    [CreatedDate] DATETIME     CONSTRAINT [DF_ExtentsionSessions_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ExtentsionSessions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

