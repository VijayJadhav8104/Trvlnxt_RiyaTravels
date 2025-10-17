CREATE TABLE [dbo].[APICachingAirlineHitCount] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Origin]       VARCHAR (50)  NULL,
    [Destination]  VARCHAR (50)  NULL,
    [OfficeID]     VARCHAR (50)  NULL,
    [Caching]      BIT           NULL,
    [CreationDate] DATETIME      CONSTRAINT [DF_APICachingAirlineHitCount_CreationDate] DEFAULT (getdate()) NULL,
    [Environment]  VARCHAR (100) NULL,
    [TrackID]      VARCHAR (MAX) NULL,
    CONSTRAINT [PK_APICachingAirlineHitCount] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250911-184303]
    ON [dbo].[APICachingAirlineHitCount]([CreationDate] ASC, [Caching] ASC, [ID] ASC)
    INCLUDE([TrackID], [Origin], [Destination], [OfficeID]);


GO
CREATE NONCLUSTERED INDEX [CommonIndex]
    ON [dbo].[APICachingAirlineHitCount]([Origin] ASC, [Destination] ASC, [OfficeID] ASC, [Caching] ASC, [Environment] ASC)
    INCLUDE([CreationDate]);

