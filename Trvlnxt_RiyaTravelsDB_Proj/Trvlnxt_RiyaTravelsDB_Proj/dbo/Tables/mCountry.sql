CREATE TABLE [dbo].[mCountry] (
    [ID]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CountryName] VARCHAR (100) NULL,
    [Currency]    VARCHAR (10)  NULL,
    [CountryCode] VARCHAR (2)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [mCountry_CountryCode]
    ON [dbo].[mCountry]([CountryCode] ASC);

