CREATE TABLE [dbo].[JazzeraOperatingCityDetails] (
    [Id]           INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirportCode]  VARCHAR (5)  NULL,
    [City]         VARCHAR (25) NULL,
    [CurrencyCode] VARCHAR (5)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

