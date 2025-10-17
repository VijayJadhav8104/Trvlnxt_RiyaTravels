CREATE TABLE [dbo].[TblAudit] (
    [Id]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Message]          TEXT          NULL,
    [AuditType]        NVARCHAR (30) NULL,
    [UserId]           INT           NULL,
    [UserName]         NVARCHAR (50) NULL,
    [PageName]         NVARCHAR (70) NULL,
    [CurrentTimeStamp] DATETIME      NULL,
    CONSTRAINT [PK_TblAudit] PRIMARY KEY CLUSTERED ([Id] ASC)
);

