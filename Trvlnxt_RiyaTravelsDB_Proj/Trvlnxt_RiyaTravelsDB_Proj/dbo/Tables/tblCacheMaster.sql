CREATE TABLE [dbo].[tblCacheMaster] (
    [id]               BIGINT        IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [cacheKey]         VARCHAR (100) NOT NULL,
    [travelDate]       DATE          NULL,
    [travelFrom]       VARCHAR (10)  NULL,
    [travelTo]         VARCHAR (10)  NULL,
    [travelClass]      VARCHAR (10)  NULL,
    [returnFrom]       VARCHAR (10)  NULL,
    [returnTo]         VARCHAR (10)  NULL,
    [returnDate]       DATE          NULL,
    [noOfAdult]        INT           NULL,
    [noOfChild]        INT           NULL,
    [noOfInfant]       INT           NULL,
    [expiredOn]        DATETIME      NULL,
    [cachedOn]         DATETIME      NULL,
    [sector]           VARCHAR (20)  NULL,
    [FlightSearchFlag] VARCHAR (20)  NULL,
    [FlightSearchData] VARCHAR (MAX) NULL,
    [IsSpecialSector]  BIT           CONSTRAINT [DF_tblCacheMaster_IsSpecialSector] DEFAULT ((0)) NULL,
    [insertedOn]       DATETIME      CONSTRAINT [DF_tblCacheMaster_insertedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblCacheMaster] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE TRIGGER dbo.[tblCacheMaster_AspNet_SqlCacheNotification_Trigger] ON dbo.tblCacheMaster
                       FOR INSERT, UPDATE, DELETE AS BEGIN
                       SET NOCOUNT ON
                       EXEC dbo.AspNet_SqlCacheUpdateChangeIdStoredProcedure N'tblCacheMaster'
                       END
