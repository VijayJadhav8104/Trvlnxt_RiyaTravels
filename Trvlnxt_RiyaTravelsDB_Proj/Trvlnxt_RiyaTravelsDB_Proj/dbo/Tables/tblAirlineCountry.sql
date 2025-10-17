CREATE TABLE [dbo].[tblAirlineCountry] (
    [ID]          BIGINT       NOT NULL,
    [CountryCode] VARCHAR (10) NULL,
    [Carrier]     VARCHAR (50) NULL,
    CONSTRAINT [PK_tblAirlineCountry] PRIMARY KEY CLUSTERED ([ID] ASC)
);

