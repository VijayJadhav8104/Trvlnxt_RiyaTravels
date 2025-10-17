CREATE TABLE [dbo].[FlatDiscount] (
    [PKId]             BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SectorType]       VARCHAR (5)  NULL,
    [AirCode]          VARCHAR (20) NULL,
    [amount]           INT          NULL,
    [Insert_date]      DATETIME     NULL,
    [UserId]           INT          NULL,
    [ModifiedDate]     DATE         NULL,
    [IsActive]         BIT          CONSTRAINT [FlatDiscount_ISActive] DEFAULT ((1)) NULL,
    [ModifiedBy]       INT          NULL,
    [FlatDiscountType] INT          NULL,
    [salesFrm_date]    DATE         NULL,
    [salesTo_date]     DATE         NULL,
    [travelFrm_date]   DATE         NULL,
    [travelTo_date]    DATE         NULL,
    [minFlatAmt]       INT          NULL,
    [maxFlatAmt]       INT          NULL,
    [Country]          VARCHAR (10) NULL,
    [Username]         VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([PKId] ASC)
);

