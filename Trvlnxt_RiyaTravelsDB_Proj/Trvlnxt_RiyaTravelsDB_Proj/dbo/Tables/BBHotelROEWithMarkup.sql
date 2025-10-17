CREATE TABLE [dbo].[BBHotelROEWithMarkup] (
    [Id]           INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromCurrency] VARCHAR (50)    NULL,
    [ToCurrency]   VARCHAR (50)    NULL,
    [Markup]       DECIMAL (18, 6) NULL,
    [TotalAmount]  DECIMAL (18, 2) NULL,
    [CreateDate]   DATETIME        NULL,
    [ModifiedDate] DATETIME        NULL,
    [CreatedBy]    INT             NULL,
    [ModifiedBy]   INT             NULL,
    [IsActive]     BIT             CONSTRAINT [DF_BBHotelROEWithMarkup_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_BBHotelROEWithMarkup] PRIMARY KEY CLUSTERED ([Id] ASC)
);

