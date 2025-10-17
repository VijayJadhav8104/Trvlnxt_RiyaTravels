CREATE TABLE [dbo].[HotelContryCurrency] (
    [CountryId]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country]     VARCHAR (50) NULL,
    [Currency]    VARCHAR (50) NULL,
    [CountryCode] VARCHAR (50) NULL,
    CONSTRAINT [PK_HotelContryCurrency] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);

