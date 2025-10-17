CREATE TABLE [dbo].[HotelDiscountDetails] (
    [Id]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromRange]   BIGINT       NULL,
    [ToRange]     BIGINT       NULL,
    [Amount]      BIGINT       NULL,
    [Percentage]  DECIMAL (18) NULL,
    [ProfileId]   INT          NULL,
    [IsActive]    TINYINT      NULL,
    [VendorId]    BIGINT       NULL,
    [txtCurrency] VARCHAR (10) NULL,
    [CountryId]   BIGINT       NULL,
    [DeletedBy]   INT          NULL,
    CONSTRAINT [PK_HotelDiscountDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

