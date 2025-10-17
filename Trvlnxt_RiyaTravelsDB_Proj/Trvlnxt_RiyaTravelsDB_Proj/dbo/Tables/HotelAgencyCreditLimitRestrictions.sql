CREATE TABLE [dbo].[HotelAgencyCreditLimitRestrictions] (
    [Id]                     INT           IDENTITY (1, 1) NOT NULL,
    [AgencyFKUserId]         INT           NOT NULL,
    [AgencyName]             VARCHAR (300) NULL,
    [AgencyIcust]            VARCHAR (100) NULL,
    [InsertedDate]           DATE          NULL,
    [CreditLimitPaymentMode] BIGINT        NOT NULL,
    CONSTRAINT [PK_HotelAgencyCreditLimitRestrictions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

