CREATE TABLE [Rail].[PricingHistory] (
    [Id]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [Fk_BookingId]    BIGINT          NULL,
    [Fk_ItemId]       BIGINT          NULL,
    [Currency]        VARCHAR (50)    NULL,
    [AgentCurrency]   VARCHAR (50)    NULL,
    [RiyaAmount]      DECIMAL (18, 2) NULL,
    [RiyaCommission]  DECIMAL (18, 2) NULL,
    [AgentAmount]     DECIMAL (18, 2) NULL,
    [AgentCommission] DECIMAL (18, 2) NULL,
    [ROE]             FLOAT (53)      NULL,
    [roeMarkup]       VARCHAR (100)   NULL,
    [FinalROE]        FLOAT (53)      NULL,
    [ReturnRatio]     DECIMAL (18, 2) NULL,
    [OperationType]   VARCHAR (50)    NULL,
    [CreatedDate]     DATETIME        CONSTRAINT [DF_PricingHistory_CreatedDate] DEFAULT (getdate()) NULL,
    [ModifiedDate]    DATETIME        NULL,
    [PaxId]           BIGINT          NULL,
    CONSTRAINT [PK_PricingHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

