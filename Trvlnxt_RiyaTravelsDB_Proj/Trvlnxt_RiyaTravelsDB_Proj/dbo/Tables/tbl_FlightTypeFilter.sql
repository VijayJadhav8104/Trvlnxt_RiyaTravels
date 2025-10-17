CREATE TABLE [dbo].[tbl_FlightTypeFilter] (
    [ID]         BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorName] VARCHAR (50) NULL,
    [FlightType] VARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_FlightTypeFilter] PRIMARY KEY CLUSTERED ([ID] ASC)
);

