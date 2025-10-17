CREATE TABLE [dbo].[AttributeSpValidation] (
    [AttributeSpValidationIDP] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKUserID]                 INT      NULL,
    [InsertedDate]             DATETIME NULL,
    [IsActive]                 BIT      NULL,
    CONSTRAINT [PK_AttributeSpValidation] PRIMARY KEY CLUSTERED ([AttributeSpValidationIDP] ASC)
);

