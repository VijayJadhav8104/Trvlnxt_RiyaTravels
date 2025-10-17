CREATE TABLE [dbo].[DyanamicPricingDetails] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [UserType]     VARCHAR (50) NULL,
    [AgentCountry] VARCHAR (50) NULL,
    [VendorName]   VARCHAR (50) NULL,
    [IsActive]     BIT          CONSTRAINT [DF_DyanamicPricingDetails_IsActive] DEFAULT ((0)) NULL,
    [InsertedDate] DATETIME     CONSTRAINT [DF_DyanamicPricingDetails_InsertedDate] DEFAULT (getdate()) NULL
);

