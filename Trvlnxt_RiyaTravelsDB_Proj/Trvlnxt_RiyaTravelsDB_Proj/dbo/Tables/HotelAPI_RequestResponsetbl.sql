CREATE TABLE [dbo].[HotelAPI_RequestResponsetbl] (
    [ID]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [APIController] NVARCHAR (50)  NULL,
    [Request]       NVARCHAR (MAX) NULL,
    [Response]      NVARCHAR (MAX) NULL,
    [Domain]        NVARCHAR (10)  NULL,
    [InsertedDate]  DATETIME       NULL,
    [BookingPkId]   BIGINT         NULL,
    [StatusID]      VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

