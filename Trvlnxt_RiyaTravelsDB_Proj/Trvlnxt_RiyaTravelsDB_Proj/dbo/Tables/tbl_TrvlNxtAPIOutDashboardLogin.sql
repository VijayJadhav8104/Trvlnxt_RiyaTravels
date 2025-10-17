CREATE TABLE [dbo].[tbl_TrvlNxtAPIOutDashboardLogin] (
    [Id]       INT          IDENTITY (1, 1) NOT NULL,
    [UserName] VARCHAR (50) NULL,
    [Password] VARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_TrvlNxtAPIOutDashboardLogin] PRIMARY KEY CLUSTERED ([Id] ASC)
);

