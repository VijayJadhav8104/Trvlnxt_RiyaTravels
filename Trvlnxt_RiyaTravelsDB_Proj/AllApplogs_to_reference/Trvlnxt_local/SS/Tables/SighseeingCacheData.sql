CREATE TABLE [SS].[SighseeingCacheData] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [CacheKey]        VARCHAR (200) NULL,
    [CacheData]       VARCHAR (MAX) NULL,
    [CacheTime]       DATETIME      NULL,
    [CacheUpdateTime] DATETIME      NULL,
    [IsActive]        BIT           NULL,
    [MethodName]      VARCHAR (200) NULL,
    CONSTRAINT [PK_SighseeingCacheData] PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([CacheKey] ASC)
);

