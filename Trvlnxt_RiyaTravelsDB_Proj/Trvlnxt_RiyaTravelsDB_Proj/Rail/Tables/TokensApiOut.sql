CREATE TABLE [Rail].[TokensApiOut] (
    [Id]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [token]      VARCHAR (MAX) NULL,
    [expiration] DATETIME      NULL,
    CONSTRAINT [PK_TokensApiOut] PRIMARY KEY CLUSTERED ([Id] ASC)
);

