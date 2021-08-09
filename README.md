# webmaster

A simple CMS client for managing content of a website. This version is built for ASME GECBH to manage the events posted on its website.
The backend is based on firebase.

## Usage

The following steps will give you an idea on how to use it for your projects

- Add your google-sevices.json to android/app/ which is obtained while creating an android project on firebase.
- Replace logo.jpg
- Add a document with id '0' to collection with name "state" in firestore with value {'events_count':0,'server_status':true}
- Add a user manually
- Initialize storage services for the project
