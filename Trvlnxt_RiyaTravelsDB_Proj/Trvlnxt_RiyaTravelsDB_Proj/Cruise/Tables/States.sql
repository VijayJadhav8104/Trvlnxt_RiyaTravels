CREATE TABLE [Cruise].[States] (
    [Id]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]      VARCHAR (100) NULL,
    [CountryId] INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

