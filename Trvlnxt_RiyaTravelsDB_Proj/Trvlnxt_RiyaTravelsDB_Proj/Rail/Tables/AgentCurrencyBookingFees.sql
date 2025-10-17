CREATE TABLE [Rail].[AgentCurrencyBookingFees] (
    [Id]            INT             IDENTITY (1, 1) NOT NULL,
    [AgentCurrency] VARCHAR (100)   NULL,
    [BookingFees]   DECIMAL (18, 2) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

