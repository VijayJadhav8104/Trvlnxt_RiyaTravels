CREATE TABLE [dbo].[tblCacheRestoration] (
    [id]            BIGINT        IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [FSReqParaJson] VARCHAR (MAX) NULL,
    [cacheKey]      VARCHAR (100) NOT NULL,
    [Remark]        VARCHAR (500) NULL,
    [createdOn]     DATETIME      CONSTRAINT [DF_tblCacheRestoration_createdOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblCacheRestoration] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-cachekey]
    ON [dbo].[tblCacheRestoration]([cacheKey] ASC);

