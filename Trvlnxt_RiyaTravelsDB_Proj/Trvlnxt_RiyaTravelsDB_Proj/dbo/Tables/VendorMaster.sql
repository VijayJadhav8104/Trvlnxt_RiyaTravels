CREATE TABLE [dbo].[VendorMaster] (
    [VId]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineType] VARCHAR (10)  NULL,
    [Vendor_No]   NVARCHAR (50) NULL,
    [IATA]        NVARCHAR (50) NULL,
    [CountryCode] NVARCHAR (3)  NULL,
    CONSTRAINT [PK_VendorMaster] PRIMARY KEY CLUSTERED ([VId] ASC)
);

