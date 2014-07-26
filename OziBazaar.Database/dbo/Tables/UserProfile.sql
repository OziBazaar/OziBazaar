CREATE TABLE [dbo].[UserProfile](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[FullName] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Activated] [bit] NOT NULL,
	[ActivationDate] [date] NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)
) 