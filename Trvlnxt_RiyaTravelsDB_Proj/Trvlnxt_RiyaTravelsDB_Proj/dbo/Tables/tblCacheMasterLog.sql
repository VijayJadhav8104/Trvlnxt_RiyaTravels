CREATE TABLE [dbo].[tblCacheMasterLog] (
    [id]       BIGINT        IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [cacheKey] VARCHAR (100) NULL,
    [date]     DATETIME      CONSTRAINT [DF_tblCacheDMLHistory_date] DEFAULT (getdate()) NULL,
    [remark]   VARCHAR (500) NULL,
    CONSTRAINT [PK_tblCacheDMLHistory] PRIMARY KEY CLUSTERED ([id] ASC)
);

