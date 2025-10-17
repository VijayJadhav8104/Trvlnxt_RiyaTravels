CREATE TABLE [dbo].[tblVisaPromoCode] (
    [Id]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PromoCode] NVARCHAR (MAX) NULL,
    [Discount]  INT            NULL,
    [UserId]    INT            NULL,
    [IP]        NVARCHAR (MAX) NULL,
    [CreatedOn] DATETIME       CONSTRAINT [DF_tblVisaPromoCode_CreatedOn] DEFAULT (getdate()) NULL,
    [IsActive]  BIT            CONSTRAINT [DF_tblVisaPromoCode_IsActive] DEFAULT ((1)) NULL,
    [UpdatedOn] DATETIME       NULL,
    [UpdatedBy] INT            NULL,
    CONSTRAINT [PK_tblVisaPromoCode] PRIMARY KEY CLUSTERED ([Id] ASC)
);

