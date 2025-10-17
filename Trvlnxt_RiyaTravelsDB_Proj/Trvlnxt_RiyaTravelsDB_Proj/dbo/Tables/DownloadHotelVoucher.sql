CREATE TABLE [dbo].[DownloadHotelVoucher] (
    [ID]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PNRNumber]     NVARCHAR (50)  NULL,
    [DownloadPaths] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

