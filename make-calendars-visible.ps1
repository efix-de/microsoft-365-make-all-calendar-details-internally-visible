# on any PC, run PowerShell as Administrator

Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement

# in the next step, you need to authenticate with your microsoft 365 admin account in a web ui
# some windows systems still default to IE which blocks the necessary scripts on the login.microsoftonline.com page
# so here you can set it to use Edge instead:
# Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice' -Name ProgId -Value 'EdgeHTML'

Connect-ExchangeOnline -UserPrincipalName ADMIN_USER@EXAMPLE.COM -DelegatedOrganization EXAMPLE_COM.onmicrosoft.com

# as a sanity check, you can list all users/mailboxes with
# Get-Mailbox

$calendars = Get-Mailbox -RecipientTypeDetails UserMailbox | Get-MailboxFolderStatistics -FolderScope Calendar | ? {$_.FolderType -eq "Calendar"} | select @{n="Identity"; e={$_.Identity.ToString().Replace("\",":\")}}

# as a sanity check, you can log the calendars with
# echo $calendars

$calendars | % {Set-MailboxFolderPermission -Identity $_.Identity -User Default -AccessRights Reviewer}

# tada.
# note that this will only set permissions for existing users/calendars, but IT IS NOT POSSIBLE to set this as a default for new users.
# you will have to re-run this script again for new users.
# see https://learn.microsoft.com/en-us/answers/questions/1192859/make-all-users-calendars-org-wide-viewable-(o365) 

Disconnect-ExchangeOnline