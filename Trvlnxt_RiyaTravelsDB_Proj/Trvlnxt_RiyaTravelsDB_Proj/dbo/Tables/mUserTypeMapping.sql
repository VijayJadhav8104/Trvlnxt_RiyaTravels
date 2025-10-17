CREATE TABLE [dbo].[mUserTypeMapping] (
    [ID]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]     INT      NOT NULL,
    [UserTypeId] INT      NOT NULL,
    [CreatedOn]  DATETIME CONSTRAINT [DF_mUserTypeMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT      NOT NULL,
    [ModifiedOn] DATETIME CONSTRAINT [DF_mUserTypeMapping_ModifiedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy] INT      NULL,
    [IsActive]   BIT      CONSTRAINT [DF_mUserTypeMapping_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mUserTypeMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

