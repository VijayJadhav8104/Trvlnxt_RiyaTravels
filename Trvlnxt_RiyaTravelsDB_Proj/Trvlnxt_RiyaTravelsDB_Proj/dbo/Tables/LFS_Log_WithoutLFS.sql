CREATE TABLE [dbo].[LFS_Log_WithoutLFS] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfficeId]    NVARCHAR (500) NOT NULL,
    [QueueNoLFS]  NVARCHAR (50)  NULL,
    [PnrNo]       NVARCHAR (50)  NULL,
    [LFS_ToEmail] NVARCHAR (MAX) NULL,
    [CreateDate]  DATETIME       NULL,
    CONSTRAINT [PK_LFS_Log_WithoutLFS] PRIMARY KEY CLUSTERED ([Id] ASC)
);

