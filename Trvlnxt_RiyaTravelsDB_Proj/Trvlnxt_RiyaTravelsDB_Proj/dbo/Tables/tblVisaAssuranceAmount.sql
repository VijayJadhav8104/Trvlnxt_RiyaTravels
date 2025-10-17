CREATE TABLE [dbo].[tblVisaAssuranceAmount] (
    [Id]             INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ActualCost]     DECIMAL (18, 2) NULL,
    [DiscountedCost] DECIMAL (18, 2) NULL,
    [CreateDate]     DATETIME        CONSTRAINT [DF_tblVisaAssuranceAmount_CreateDate] DEFAULT (getdate()) NULL,
    [AddedBy]        INT             NULL,
    [IsActive]       BIT             CONSTRAINT [DF_tblVisaAssuranceAmount_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblVisaAssuranceAmount] PRIMARY KEY CLUSTERED ([Id] ASC)
);

