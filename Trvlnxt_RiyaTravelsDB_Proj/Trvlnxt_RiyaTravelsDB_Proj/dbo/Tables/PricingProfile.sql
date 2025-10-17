CREATE TABLE [dbo].[PricingProfile] (
    [Id]             INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProfileName]    NVARCHAR (200)  NULL,
    [DefaultProfile] BIT             NULL,
    [CreateDate]     DATETIME        CONSTRAINT [DF_PricingProfile_CreateDate] DEFAULT (getdate()) NULL,
    [CreatedBy]      INT             NULL,
    [ModifiedOn]     DATETIME        NULL,
    [ModifiedBy]     INT             NULL,
    [IsActive]       BIT             CONSTRAINT [DF_PricingProfile_IsActive] DEFAULT ((1)) NULL,
    [Commission]     DECIMAL (18, 2) NULL,
    [GST]            DECIMAL (18, 2) NULL,
    [TDS]            DECIMAL (18, 2) NULL,
    [CountryMarket]  VARCHAR (20)    CONSTRAINT [DF_PricingProfile_CountryMarket] DEFAULT ((0)) NULL,
    [Currency]       VARCHAR (30)    CONSTRAINT [DF_PricingProfile_Currency] DEFAULT ((0)) NULL,
    [CommissionOn]   VARCHAR (100)   NULL,
    [CommissionAmt]  DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_PricingProfile] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([ProfileName] ASC)
);

