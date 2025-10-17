CREATE TABLE [dbo].[tblCacheMasterRemoveItems] (
    [id]               BIGINT         IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [cacheKey]         VARCHAR (100)  NOT NULL,
    [travelDate]       DATE           NULL,
    [travelFrom]       VARCHAR (10)   NULL,
    [travelTo]         VARCHAR (10)   NULL,
    [travelClass]      VARCHAR (10)   NULL,
    [returnFrom]       VARCHAR (10)   NULL,
    [returnTo]         VARCHAR (10)   NULL,
    [returnDate]       DATE           NULL,
    [noOfAdult]        INT            NULL,
    [noOfChild]        INT            NULL,
    [noOfInfant]       INT            NULL,
    [expiredOn]        DATETIME       NULL,
    [cachedOn]         DATETIME       NULL,
    [signature]        VARCHAR (5000) NULL,
    [FlightSearchData] VARCHAR (MAX)  NULL,
    [IsSpecialSector]  BIT            CONSTRAINT [DF_tblCacheMasterRemoveItems_IsSpecialSector] DEFAULT ((0)) NULL,
    [insertedOn]       DATETIME       CONSTRAINT [DF_tblCacheMasterRemoveItems_insertedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblCacheMasterRemoveItems] PRIMARY KEY CLUSTERED ([id] ASC)
);

