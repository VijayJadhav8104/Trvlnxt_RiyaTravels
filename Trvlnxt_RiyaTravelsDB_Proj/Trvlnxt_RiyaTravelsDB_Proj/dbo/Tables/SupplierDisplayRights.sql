CREATE TABLE [dbo].[SupplierDisplayRights] (
    [Id]                  INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkmUserId]           INT          NULL,
    [DisplayRights]       BIT          NULL,
    [CreatedBy]           INT          NULL,
    [CreatedOn]           DATETIME     CONSTRAINT [DF_SupplierDisplayRights_CreatedOn] DEFAULT (getdate()) NULL,
    [ModifiedBy]          INT          NULL,
    [ModifiedOn]          DATETIME     NULL,
    [IsActive]            BIT          CONSTRAINT [DF_SupplierDisplayRights_IsActive] DEFAULT ((1)) NULL,
    [FKB2bRegistrationId] INT          NULL,
    [UserType]            VARCHAR (50) NULL,
    CONSTRAINT [PK_SupplierDisplayRights] PRIMARY KEY CLUSTERED ([Id] ASC)
);

