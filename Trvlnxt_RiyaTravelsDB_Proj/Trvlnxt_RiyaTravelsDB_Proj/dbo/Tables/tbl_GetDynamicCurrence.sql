CREATE TABLE [dbo].[tbl_GetDynamicCurrence] (
    [ID]       INT          NOT NULL,
    [UserType] VARCHAR (20) CONSTRAINT [DF__tbl_GetDy__UserT__6BF08837] DEFAULT (NULL) NULL,
    [Currency] VARCHAR (20) CONSTRAINT [DF__tbl_GetDy__Curre__6CE4AC70] DEFAULT (NULL) NULL,
    CONSTRAINT [PK_tbl_GetDynamicCurrence] PRIMARY KEY CLUSTERED ([ID] ASC)
);

