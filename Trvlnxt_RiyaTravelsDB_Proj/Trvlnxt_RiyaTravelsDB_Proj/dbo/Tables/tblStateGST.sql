CREATE TABLE [dbo].[tblStateGST] (
    [id]          BIGINT         NOT NULL,
    [States_Code] NVARCHAR (255) NULL,
    [Description] NVARCHAR (255) NULL,
    [GST_Reg_No]  NVARCHAR (255) NULL,
    [GST_Type]    NVARCHAR (255) NULL,
    CONSTRAINT [PK_tblStateGST] PRIMARY KEY CLUSTERED ([id] ASC)
);

