CREATE TABLE [Hotel].[CardDetailsPayHotel] (
    [Id]             INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookingId]    INT          NULL,
    [CardHolderName] NCHAR (100)  NULL,
    [CardNo]         NCHAR (100)  NULL,
    [Cvv]            NCHAR (100)  NULL,
    [CardExpiry]     NCHAR (100)  NULL,
    [insertdate]     DATETIME     NULL,
    [Address1]       NCHAR (100)  NULL,
    [Address2]       NCHAR (100)  NULL,
    [Country]        NCHAR (100)  NULL,
    [City]           NCHAR (100)  NULL,
    [PostalCode]     INT          NULL,
    [State]          NCHAR (100)  NULL,
    [CountryCode]    VARCHAR (50) NULL,
    [CardType]       VARCHAR (20) NULL,
    CONSTRAINT [PK_CardDetailsPayHotel] PRIMARY KEY CLUSTERED ([Id] ASC)
);

