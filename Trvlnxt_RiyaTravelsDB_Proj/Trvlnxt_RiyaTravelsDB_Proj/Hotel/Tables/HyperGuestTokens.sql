CREATE TABLE [Hotel].[HyperGuestTokens] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SupplierId]  INT           NULL,
    [Token]       VARCHAR (100) NULL,
    [BasedOn]     VARCHAR (50)  NULL,
    [CountryCode] VARCHAR (50)  NULL,
    CONSTRAINT [PK_HyperGuestTokens] PRIMARY KEY CLUSTERED ([Id] ASC)
);

