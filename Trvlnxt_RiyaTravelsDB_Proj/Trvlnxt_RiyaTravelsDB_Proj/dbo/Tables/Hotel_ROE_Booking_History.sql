CREATE TABLE [dbo].[Hotel_ROE_Booking_History] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookId]     INT            NULL,
    [BookingRefNo] VARCHAR (100)  NULL,
    [FromCurrency] VARCHAR (50)   NULL,
    [ToCurrency]   VARCHAR (50)   NULL,
    [FkROE_Id]     INT            NULL,
    [Rate]         NVARCHAR (200) NULL,
    [CreateDate]   DATETIME       CONSTRAINT [DF_Hotel_ROE_Booking_History_CreateDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Hotel_ROE_Booking_History] PRIMARY KEY CLUSTERED ([Id] ASC)
);

