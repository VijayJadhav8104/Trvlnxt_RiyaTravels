CREATE TABLE [dbo].[tblBranchDimension] (
    [Id]             INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Branch]         VARCHAR (20) NULL,
    [BranchLocation] VARCHAR (50) NULL,
    [Dimension]      VARCHAR (20) NULL,
    [CityName]       VARCHAR (20) NULL,
    [StateId]        INT          NULL,
    [RCBranch]       VARCHAR (20) NULL,
    [IsRequired]     BIT          CONSTRAINT [DF_tblBranchDimension_IsRequired] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblBranchDimension] PRIMARY KEY CLUSTERED ([Id] ASC)
);

