CREATE TABLE [dbo].[tblBlockedAirlinePromoCode] (
    [ID]         BIGINT       NOT NULL,
    [FromSector] VARCHAR (50) NULL,
    [ToSector]   VARCHAR (50) NULL,
    [Airline]    VARCHAR (50) NULL,
    [PromoCode]  VARCHAR (50) NULL,
    [IsActive]   BIT          NULL,
    CONSTRAINT [PK_tblBlockedAirlinePromoCode] PRIMARY KEY CLUSTERED ([ID] ASC)
);

