CREATE TABLE [dbo].[USDAgentCardDetails] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [FKBookId]       INT           NULL,
    [InsertedDate]   DATETIME      NULL,
    [CardFullName]   VARCHAR (400) NULL,
    [CardNumber]     VARCHAR (400) NULL,
    [CardExpiryDate] VARCHAR (50)  NULL,
    [ProductType]    VARCHAR (50)  NULL,
    CONSTRAINT [PK_USDAgentCardDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

