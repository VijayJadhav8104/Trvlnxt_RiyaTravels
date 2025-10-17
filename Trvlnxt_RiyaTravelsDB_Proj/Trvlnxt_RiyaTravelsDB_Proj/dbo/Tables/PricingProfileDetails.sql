CREATE TABLE [dbo].[PricingProfileDetails] (
    [Id]               INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromRange]        NVARCHAR (500)  NULL,
    [ToRange]          NVARCHAR (500)  NULL,
    [Amount]           DECIMAL (18, 2) NULL,
    [PricePercent]     DECIMAL (18, 2) NULL,
    [FKPricingProfile] INT             NULL,
    [CreateDate]       DATETIME        CONSTRAINT [DF_PricingProfileDetails_CreateDate] DEFAULT (getdate()) NULL,
    [IsActive]         BIT             CONSTRAINT [DF_PricingProfileDetails_IsActive] DEFAULT ((1)) NULL,
    [RowNo]            INT             NULL,
    CONSTRAINT [PK_PricingProfileDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

