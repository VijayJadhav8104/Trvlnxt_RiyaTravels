CREATE TABLE [Hotel].[HotelAutoHCN] (
    [Pkid]                    INT            IDENTITY (1, 1) NOT NULL,
    [BookingReference]        VARCHAR (200)  NULL,
    [HotelConfirmationNumber] VARCHAR (800)  NULL,
    [IsActive]                BIT            NULL,
    [CreatedDate]             DATETIME       NULL,
    [ProviderRefNumber]       NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

