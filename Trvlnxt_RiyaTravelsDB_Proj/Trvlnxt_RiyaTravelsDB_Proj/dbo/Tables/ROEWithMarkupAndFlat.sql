CREATE TABLE [dbo].[ROEWithMarkupAndFlat] (
    [Id]            INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Products]      VARCHAR (100)   NULL,
    [UserTypeId]    INT             NULL,
    [FromCurrency]  VARCHAR (50)    NULL,
    [ToCurrency]    VARCHAR (50)    NULL,
    [MarkupType]    VARCHAR (50)    NULL,
    [MarkupData]    FLOAT (53)      NULL,
    [IsAddSubtract] INT             NULL,
    [MarkupAmount]  DECIMAL (18, 6) NULL,
    [FinalROE]      DECIMAL (18, 6) NULL,
    [IsActive]      BIT             CONSTRAINT [DF_BBHotelROEWithMarkupAndFlat_Isactive] DEFAULT ((1)) NULL,
    [CreatedBy]     BIGINT          NULL,
    [CreateDate]    DATETIME        NULL,
    [ModifiedBy]    BIGINT          NULL,
    [ModifiedDate]  DATETIME        NULL,
    CONSTRAINT [PK_BBHotelROEWithMarkupAndFlat] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - Plus, 0 - Minus', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ROEWithMarkupAndFlat', @level2type = N'COLUMN', @level2name = N'IsAddSubtract';

