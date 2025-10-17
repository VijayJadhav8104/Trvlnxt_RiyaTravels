CREATE TABLE [dbo].[BasedOnSupplierMapping] (
    [Id]               INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]          INT          NULL,
    [CombinationNo]    INT          NULL,
    [BasedOnSupplier]  INT          NULL,
    [IsCheck]          BIT          NULL,
    [CombinationCount] INT          NULL,
    [CreateDate]       DATETIME     CONSTRAINT [DF_BasedOnSupplierMapping_CreateDate] DEFAULT (getdate()) NULL,
    [CreatedBy]        INT          NULL,
    [ModifiedDate]     DATETIME     NULL,
    [ModifiedBy]       INT          NULL,
    [IsActive]         BIT          CONSTRAINT [DF_BasedOnSupplierMapping_IsActive] DEFAULT ((1)) NULL,
    [Usertype]         VARCHAR (50) NULL,
    [Country]          VARCHAR (50) NULL,
    CONSTRAINT [PK_BasedOnSupplierMapping] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([AgentId] ASC, [CombinationNo] ASC, [BasedOnSupplier] ASC)
);

