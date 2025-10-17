CREATE TABLE [dbo].[tblCacheRestorationLog] (
    [id]         BIGINT        IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [cacheKey]   VARCHAR (100) NOT NULL,
    [Remark]     VARCHAR (500) NULL,
    [date]       DATETIME      NULL,
    [insertedOn] DATETIME      CONSTRAINT [DF_tblCacheRestorationLog_createdOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblCacheRestorationLog] PRIMARY KEY CLUSTERED ([id] ASC)
);

