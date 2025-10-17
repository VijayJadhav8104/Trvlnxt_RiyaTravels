CREATE TABLE [dbo].[ConsoleErrorLog] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PageName]         VARCHAR (100)  NULL,
    [MethodName]       VARCHAR (100)  NULL,
    [GDSPNR]           VARCHAR (100)  NULL,
    [ExceptionMessage] NVARCHAR (MAX) NULL,
    [Message]          NVARCHAR (MAX) NULL,
    [StackTrace]       NVARCHAR (MAX) NULL,
    [Details]          NVARCHAR (MAX) NULL,
    [InsertedDate]     VARCHAR (100)  NULL,
    CONSTRAINT [PK_ConsoleErrorLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

