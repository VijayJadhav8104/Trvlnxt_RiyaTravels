CREATE TABLE [dbo].[B2B_Promotion] (
    [Id]                  INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MarketPoint]         VARCHAR (30)    NOT NULL,
    [UserType]            VARCHAR (50)    NOT NULL,
    [Supplier]            INT             NOT NULL,
    [PromotionName]       VARCHAR (1100)  NOT NULL,
    [TravelValidityFrom]  DATETIME        NULL,
    [TravelValidityTo]    DATETIME        NULL,
    [BookingValidityFrom] DATETIME        NULL,
    [BookingValidityTo]   DATETIME        NULL,
    [Amount]              NUMERIC (18, 2) NULL,
    [Percentage]          NUMERIC (18, 2) NULL,
    [GroupType]           VARCHAR (50)    NOT NULL,
    [IsActive]            BIT             CONSTRAINT [DF_B2B_Promotion_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertedBy]          INT             NOT NULL,
    [InsertedDate]        DATETIME        CONSTRAINT [DF_B2B_Promotion_InsertedDate] DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]           INT             NULL,
    [UpdatedDate]         DATETIME        NULL,
    [IsSupplier]          BIT             NULL,
    [ActionStatus]        BIT             CONSTRAINT [DF_B2B_Promotion_ActionStatus] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_B2B_Promotion] PRIMARY KEY CLUSTERED ([Id] ASC)
);

