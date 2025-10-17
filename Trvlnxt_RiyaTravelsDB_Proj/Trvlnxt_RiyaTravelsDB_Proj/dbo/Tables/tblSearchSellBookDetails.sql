CREATE TABLE [dbo].[tblSearchSellBookDetails] (
    [ID]            BIGINT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [StaffID]       INT              NULL,
    [AgentID]       INT              NULL,
    [SubUserID]     INT              NULL,
    [Origin]        VARCHAR (10)     NULL,
    [Destination]   VARCHAR (10)     NULL,
    [DepartureDate] DATETIME         NULL,
    [ArrivalDate]   DATETIME         NULL,
    [Country]       VARCHAR (10)     NULL,
    [Status]        VARCHAR (20)     NULL,
    [BookFrom]      VARCHAR (20)     NULL,
    [SearchDate]    DATETIME         NULL,
    [SellDate]      DATETIME         NULL,
    [BookedDate]    DATETIME         NULL,
    [FareAmount]    NUMERIC (18, 2)  NULL,
    [OfficeID]      VARCHAR (50)     NULL,
    [JounrneyType]  VARCHAR (30)     NULL,
    [ArlineCode]    VARCHAR (10)     NULL,
    [Environment]   VARCHAR (30)     NULL,
    [TrackID]       UNIQUEIDENTIFIER NULL,
    [EntryDate]     DATETIME         CONSTRAINT [DF_tblSearchSellBookDetails_EntryDate] DEFAULT (getdate()) NULL,
    [TrackingID]    VARCHAR (100)    NULL,
    CONSTRAINT [PK_tblSearchSellBookDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [noncluster_compositeIndex]
    ON [dbo].[tblSearchSellBookDetails]([Environment] ASC, [EntryDate] ASC)
    INCLUDE([AgentID], [Origin], [Destination], [Country], [Status], [BookFrom]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20241014-151503]
    ON [dbo].[tblSearchSellBookDetails]([EntryDate] ASC, [BookFrom] ASC, [Country] ASC);

