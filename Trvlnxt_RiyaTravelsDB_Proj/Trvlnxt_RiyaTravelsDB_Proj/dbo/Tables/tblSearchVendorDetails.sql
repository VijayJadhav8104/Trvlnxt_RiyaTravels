CREATE TABLE [dbo].[tblSearchVendorDetails] (
    [ID]         BIGINT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TrackID]    UNIQUEIDENTIFIER NULL,
    [OfficeID]   VARCHAR (50)     NULL,
    [Caching]    BIT              NULL,
    [EntryDate]  DATETIME         CONSTRAINT [DF_tblSearchVendorDetails_EntryDate] DEFAULT (getdate()) NULL,
    [TrackingID] VARCHAR (100)    NULL,
    CONSTRAINT [PK_tblSearchVendorDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);

