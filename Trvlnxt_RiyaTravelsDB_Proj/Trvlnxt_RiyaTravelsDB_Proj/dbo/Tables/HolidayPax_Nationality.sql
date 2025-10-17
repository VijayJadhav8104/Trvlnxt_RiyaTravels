CREATE TABLE [dbo].[HolidayPax_Nationality] (
    [Nationality_Id]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Nationality_Name] VARCHAR (50) NOT NULL,
    [IsActive]         INT          CONSTRAINT [DF_HolidayPax_Nationality_Status] DEFAULT ((1)) NOT NULL,
    [InsertDate]       DATETIME     CONSTRAINT [DF_HolidayPax_Nationality_InsertDate] DEFAULT (getdate()) NOT NULL,
    [InsertBy]         INT          NOT NULL,
    [UpdateDate]       DATETIME     NULL,
    [UpdateBy]         INT          NULL,
    [DeleteDate]       DATETIME     NULL,
    [DeleteBy]         INT          NULL,
    CONSTRAINT [PK_HolidayPax_Nationality] PRIMARY KEY CLUSTERED ([Nationality_Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 Deactive, 1 Active', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HolidayPax_Nationality', @level2type = N'COLUMN', @level2name = N'IsActive';

