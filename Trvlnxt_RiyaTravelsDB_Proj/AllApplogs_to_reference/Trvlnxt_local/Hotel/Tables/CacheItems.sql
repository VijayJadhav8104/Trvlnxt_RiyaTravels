CREATE TABLE [Hotel].[CacheItems] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [CachedData]     VARCHAR (MAX)  NULL,
    [ExpirationDate] DATETIME       NULL,
    [InsertedDate]   DATETIME       CONSTRAINT [DF_CacheItems_InsertedDate] DEFAULT (getdate()) NULL,
    [CacheKey]       VARCHAR (1700) NULL,
    [LocationId]     VARCHAR (150)  NULL,
    [LocationType]   VARCHAR (200)  NULL,
    CONSTRAINT [PK_CacheItems] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_column_name_filtered]
    ON [Hotel].[CacheItems]([CacheKey] ASC) WHERE ([CacheKey] IS NOT NULL);

