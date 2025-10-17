CREATE TABLE [Hotel].[DestinationwiseCountryList] (
    [Countryid]   INT            IDENTITY (1, 1) NOT NULL,
    [CountryName] NVARCHAR (500) NULL,
    [IsActive]    BIT            NULL,
    PRIMARY KEY CLUSTERED ([Countryid] ASC)
);

