# MeCAT: Peer Evaluation Tool
Peer evaluations are an important component of the grading rubric for various group projects and tasks. The feedback from these peer evaluation forms lets instructors know how the group felt about their project, and includes responses from students on their team-members. This is a web application written with Ruby on Rails that does just that.

## How to Run
To run this project, download this projec to your machine. After downloading, navigate to the root directory of this project within your Ubuntu terminal. 

Within the Ubuntu terminal, run the command:
```
$ bundle install
```

This will install all necessary Gems needed for this application.

Before running rails server, you first need to migrate the database using the command:
```
$ rails db:migrate
```

Finally, still in the root directory folder, run the command:
```
$ rails server
```

This will print the following to the console:

```
=> Booting Puma
=> Rails 6.0.3.6 application starting in development 
=> Run `rails server --help` for more startup options
Puma starting in single mode...
* Version 4.3.7 (ruby 2.6.6-p146), codename: Mysterious Traveller
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://127.0.0.1:3000
* Listening on tcp://[::1]:3000
Use Ctrl-C to stop
```

Now that a Rails server instance has been successfully launched on your local machine, you can navigate to your favorite web-browser and interact with the server. 

Navigate to the following url in your browser to view the application:

```
http://localhost:3000
```

## Additional Extensions
* Password Hashing
* Authenticated Users
* Uniqueness

### Testing Functionality
To test the functionality of this web application, click the Generate Data button on the main screen. This will generate 12 students, named student1-12, and 1 instructor, named Charlie. All users have passwords '123456'. Charlie will have one class called 'Web-Apps', which includes 3 groups of students. 

To reset all data, click the Reset Data button.

## Contributions

### Team: //Todo: Make team name

Esther Hu

Evan Hubert

Zehur Elmi

Nick Springer

