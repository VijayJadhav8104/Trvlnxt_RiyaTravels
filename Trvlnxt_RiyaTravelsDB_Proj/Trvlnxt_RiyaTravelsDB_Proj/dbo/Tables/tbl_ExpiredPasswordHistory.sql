CREATE TABLE [dbo].[tbl_ExpiredPasswordHistory] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [UserID]             BIGINT        NULL,
    [PasswordExpiryDate] DATETIME      NULL,
    [ExpiredPassword]    VARCHAR (300) NULL,
    CONSTRAINT [PK_tbl_ExpiredPasswordHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

