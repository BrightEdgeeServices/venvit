print ('Hello world')

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
import os
import json

# Google Drive service account credentials
SCOPES = ['https://www.googleapis.com/auth/drive']

# Folder ID of your Google Drive folder
FOLDER_ID = '1Kb5migDA2erszx5A7maJdpV_4su4-dK7'

# Path to the directory containing files to upload
FILES_DIRECTORY = '-'

def main():
    # Load credentials from environment variable
    service_account_info = json.loads(os.environ['SERVICE_ACCOUNT_JSON'])
    credentials = service_account.Credentials.from_service_account_info(
        service_account_info, scopes=SCOPES)
    service = build('drive', 'v3', credentials=credentials)

    # List files in the directory
    for filename in os.listdir(FILES_DIRECTORY):
        file_path = os.path.join(FILES_DIRECTORY, filename)
        if os.path.isfile(file_path):
            upload_file(service, file_path, filename)

def upload_file(service, file_path, filename):
    file_metadata = {
        'name': filename,
        'parents': [FOLDER_ID]
    }
    media = MediaFileUpload(file_path, resumable=True)
    file = service.files().create(body=file_metadata, media_body=media, fields='id').execute()
    print(f"Uploaded file {filename} with file ID {file.get('id')}")

if __name__ == '__main__':
    main()