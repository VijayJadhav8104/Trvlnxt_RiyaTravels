CREATE TABLE [dbo].[mCountryCurrency] (
    [Id]           INT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CountryCode]  VARCHAR (5) NOT NULL,
    [CurrencyCode] VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_mCountryCurrency] PRIMARY KEY CLUSTERED ([Id] ASC)
);

