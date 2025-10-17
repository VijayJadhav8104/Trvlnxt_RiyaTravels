CREATE TABLE [dbo].[HotelCacheData] (
    [id]                INT           IDENTITY (1, 1) NOT NULL,
    [CacheKey]          VARCHAR (200) NULL,
    [CacheData]         VARCHAR (MAX) NULL,
    [CacheTime]         DATETIME      NULL,
    [CacheUpdateTime]   DATETIME      NULL,
    [IsActive]          BIT           NULL,
    [MethodName]        VARCHAR (200) NULL,
    [CacheInsertedTIme] DATETIME      CONSTRAINT [DF_HotelCacheData_CacheInsertedTIme] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_HotelCacheData] PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([CacheKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_cachekey]
    ON [dbo].[HotelCacheData]([CacheKey] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-isactive-20230727-115935]
    ON [dbo].[HotelCacheData]([IsActive] ASC);

