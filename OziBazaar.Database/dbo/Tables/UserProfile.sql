CREATE TABLE [dbo].[UserProfile](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[FullName] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Activated] [bit] NULL,
	[ActivationDate] [date] NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)
)
GO
/****** Object:  Index [IX_UserProfile]    Script Date: 2/08/2014 6:26:21 PM ******/
/****** Object:  Index [IX_UserProfile]    Script Date: 18/08/2014 10:09:10 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserProfile] ON [dbo].[UserProfile]
(
	[UserName] ASC
)
GO
/****** Object:  Index [IX_UserProfile_UniqueEmail]    Script Date: 2/08/2014 6:26:21 PM ******/
/****** Object:  Index [IX_UserProfile_UniqueEmail]    Script Date: 18/08/2014 10:09:10 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserProfile_UniqueEmail] ON [dbo].[UserProfile]
(
	[EmailAddress] ASC
)