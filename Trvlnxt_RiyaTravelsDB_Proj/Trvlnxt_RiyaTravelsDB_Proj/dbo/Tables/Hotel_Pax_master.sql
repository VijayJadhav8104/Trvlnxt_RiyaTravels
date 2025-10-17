CREATE TABLE [dbo].[Hotel_Pax_master] (
    [Salutation]     VARCHAR (10)   NULL,
    [FirstName]      VARCHAR (150)  NULL,
    [LastName]       VARCHAR (150)  NULL,
    [PassengerType]  VARCHAR (50)   NULL,
    [Age]            VARCHAR (5)    NULL,
    [CotBedOption]   VARCHAR (30)   NULL,
    [book_fk_id]     BIGINT         NULL,
    [orderId]        VARCHAR (30)   NULL,
    [IsCancelled]    INT            NULL,
    [IsBooked]       INT            NULL,
    [inserteddate]   DATETIME       NULL,
    [room_fk_id]     BIGINT         NULL,
    [PassportNum]    VARCHAR (30)   NULL,
    [IssueDate]      VARCHAR (100)  NULL,
    [Expirydate]     VARCHAR (100)  NULL,
    [Nationality]    VARCHAR (150)  NULL,
    [Pancard]        NVARCHAR (200) NULL,
    [ISDCode]        VARCHAR (50)   NULL,
    [Contact]        VARCHAR (200)  NULL,
    [Email]          VARCHAR (200)  NULL,
    [ID]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RoomNo]         VARCHAR (50)   NULL,
    [RoomType]       VARCHAR (MAX)  NULL,
    [MealBasis]      VARCHAR (300)  NULL,
    [IsLeadPax]      BIT            NULL,
    [PanCardName]    VARCHAR (200)  NULL,
    [PassPortDOB]    VARCHAR (100)  NULL,
    [PANDateOfBirth] VARCHAR (500)  NULL,
    CONSTRAINT [PK__Hotel_Pa__3214EC275137E845] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_book_fk_id]
    ON [dbo].[Hotel_Pax_master]([book_fk_id] ASC, [room_fk_id] ASC, [IsLeadPax] ASC)
    INCLUDE([PassportNum], [IssueDate], [PassPortDOB], [Expirydate], [Pancard], [PanCardName]);

