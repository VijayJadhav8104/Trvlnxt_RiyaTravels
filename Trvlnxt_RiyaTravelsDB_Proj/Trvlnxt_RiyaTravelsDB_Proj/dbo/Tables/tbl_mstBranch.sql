CREATE TABLE [dbo].[tbl_mstBranch] (
    [BranchId]      INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BranchName]    VARCHAR (50) NULL,
    [LocationCode]  VARCHAR (50) NULL,
    [NewBranchCode] VARCHAR (50) NULL,
    [City]          VARCHAR (50) NULL,
    [State]         VARCHAR (50) NULL,
    [Zone]          VARCHAR (50) NULL,
    [StateId]       INT          NULL,
    [Active]        BIT          NULL,
    CONSTRAINT [PK_tbl_mstBranch] PRIMARY KEY CLUSTERED ([BranchId] ASC)
);

