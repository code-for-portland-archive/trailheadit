Trailheadit
=========

This project was created during the 2014 National Day of Civic Hacking event in Porland, Oregon. The goal of the project is to provide an open solution for the collection of trailhead data via GPS tagged photos. A user in the field can simply take a photo of a trailhead and email the photo to an instance of this backend. The backend would then parse the location data from the EXIF headers in the photo and create a new Trailhead object. The accumulated trailhead objects can then be saved in the OpenTrails open data specification.

traileditor.org
=========

An instance of this application, sponsored by [Trailhead Labs](http://www.trailheadlabs.com), is accessible at http://www.traileditor.org and is hosted on [Heroku](http://www.heroku.com).

Ruby on Rails
-------------

This application requires:

-   Ruby
-   Rails


Database
--------

This application uses PostgreSQL with ActiveRecord.

Development
-----------

-   Template Engine: Haml
-   Testing Framework: Test::Unit
-   Front-end Framework: Bootstrap 3.0 (Sass)
-   Form Builder: SimpleForm

Email
-----

The application is configured to send and receive email using the MailGun service and API.

Email delivery is disabled in development.

Documentation and Support
-------------------------

This is the only documentation (for now).

Related Projects
----------------

* PDX Trails iOS Application
* To the Trails PhoneGap Application

Contributing
------------

If you make improvements to this application, please share with others.

-   Fork the project on GitHub.
-   Make your feature addition or bug fix.
-   Commit with Git.
-   Send the author a pull request.

If you add functionality to this application, create an alternative
implementation, or build an application that is similar, please contact
me and I’ll add a note to the README so that others can find your work.

Credits
-------

Hackathon Sprint Team

* Alan Williams ( Code for America )
* Dale Hollocher
* Jereme Monteau ( Trailhead Labs )
* Ryan Branciforte ( Trailhead Labs )
* Razaik Singh
* Zac Christiansen ( Oregon Metro )

Special Thanks To 

* Code For Portland 
* NORTH
