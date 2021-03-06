To report a bug, use GitHub Issues if you have access.
https://github.com/MichaelHoffmann/AGORA/issues

README last updated December 2, 2011 by Joshua Justice ("JoshJGT" on GitHub).

This development effort was primarily split into two parts- Joshua working primarily on the serverside component while Arun and Mona worked on the client side component.

As such, this README is going to be focused primarily on explaining how the server side code works.

Each PHP file represents a thing which a person can do to a map, though insert.php in particular handles a great many functions.
This README will quickly explain the logic behind the system, then go into detail on each individual PHP file.

If you are setting it up on your server for the first time, you MUST look at the entry for configure.php and establish_link.php


# LOGIC

* a MAP is essentially a visual representation of an argument.

* a NODE is the main thing visible on the map.

* a TEXTBOX is the container for the text which is in one (or more) nodes.

* a NODETEXT item is the mapping between a node and a textbox. This is a N:N mapping - one node can contain multiple textboxes, connected in various ways. For instance, in the phrase "if P, then Q", the textboxes would be P and Q: the user-modifiable text. The NODETEXT system is used rather than storing the text in a node because P is likely to be a textbox in another node by itself. An ASCII diagram follows:

```
       Q<----therefore----P
                 |
                 |
                 |
            If P, then Q
```
		
In this diagram, Q is the claim, P is the reason, and "If P, then Q" is the enabler: the piece of logic which makes this a logically valid argument. (Note that "logically valid" doesn't mean it's true, just that it's logically consistent. If someone makes the argument "If bananas are yellow, then it will rain tomorrow" you could make an objection that the reason does not actually support the claim, and that this enabler is invalid.)

* a CONNECTION is the mapping between an "argument" itself and the claim. It is where the "therefore" is located in the diagram above. This is not called an argument because you can also use it for things other than arguments: see the connection_types table for a list of things. (Note that this is a separate table rather than an ENUM to support the future possibility of dynamically adding types of connections!) This is a N:1 mapping- any CONNECTION can have only one NODE which it points to, but any NODE can have multiple CONNECTIONS from it.

* a SOURCENODE is a mapping between CONNECTIONS and the NODEs which are the "source" of this argument. They have a N:1 mapping to CONNECTIONS - any SOURCENODE can point to only one CONNECTION, but a CONNECTION can have multiple SOURCENODES. As in the above diagram, the default "argument" has 2 sourcenodes for one connection - this is typical (though by no means mandatory!). Something like an Objection would have 1 sourcenode - the objection node itself. (In theory, this could be a column in the NODE table to ensure N:1 mapping, but in practice I felt that making it a separate table was cleaner.)

## PROJECTS
As this system was designed for use in a classroom environment, an additional feature was desired for restricting access to maps and allowing greater flexibility.

Projects offer two capabilities. One is to restrict access to maps to only a limited number of people (either added by hand, or self-joining by means of a shared password). The other is to allow "cooperate" maps rather than "debate" maps - maps which let people edit each others' stuff. (Normally, people cannot edit their own stuff.)

* a PROJECT is the actual project itself. The user_id is the owner of the project.

* a PROJUSER is a mapping between projects and users. This is a N:N relationship, obviously - any user can be in multiple projects, and any project can have multiple users.

* a "debate" map is a normal map. Any map not in a project is a "debate" map, and project maps default to "debate" mode. Cooperative maps override the requirement that I be the one to edit my own stuff.

# SERVERSIDE INFORMATION

## FILE BY FILE

CHANGEINFO.PHP: lets a user change his personal information, including password. If the "newpass" field is left blank, the system will leave the password alone.

CHARTEST.PHP: A file for testing out storage/retrieval of unicode text to make sure our system could handle foreign characters. If you see a bunch of boxes in the file, your text editor doesn't handle it well; try notepad++ or emacs.

CONFIGURE.PHP: A file which the programs use to see which database to hit. We only had one server for both development and production, so to keep our test stuff from clogging up the public map list, we created a development database which was a copy of the production database. ***MAKE SURE THAT $dbName POINTS TO THE CORRECT DATABASE!*** The other variables don't actually DO anything, though $version does get echoed in places.

ERRORCODES.PHP: A file for standardizing error messages.

ESTABLISH_LINK.PHP: A file for centralizing the database connection so that the actual password wouldn't have to be placed everywhere. ***MAKE SURE TO EDIT THE mysql_connect FUNCTION TO USE THE PROPER USERNAME AND PASSWORD!***

FORGOT_PASS.PHP: A file for handling forgotten passwords. This creates a new password, e-mails it to the user in 3 languages, and stores the hash in the server. If your server cannot e-mail users, then this file should not be placed on your server.

INSERT.PHP: The file for handling inserting/updating parts of maps, as well as for creating maps themselves.

JOIN_PRJ.PHP: The file for joining projects via shared password.

LASTVIEWED.PHP: If the client sends stuff here, the server will track the last time a user has viewed any particular map. This can be compared to the last time a map has been modified to allow the client to highlight maps with new content.

LIST_MAPS.PHP: Lists all maps not in a project.

LIST_PROJECTS.PHP: Lists all projects.

(Both of the above have a MY_ version which takes in a user ID and password, and returns a list of all the ones belonging to that user.)

LOAD_MAP.PHP: Returns an XML version of the map.

LOAD_PRJ.PHP: Returns an XML version of the project - all its maps and users.

LOGIN.PHP: Upon logging into this with a username and password, you get back the user ID. All access to user-specific functions is done with the user ID later on.

MAPINFO.PHP: This file handles changing map information - its title, description, etc.

MY_MAPS.PHP: Lists all maps a particular user owns or has participated in, but not the ones in a project.

MY_PROJECTS.PHP: Lists all projects a user is part of.

PROJECTS.PHP: The file for creating and editing projects.

PROJMAPS.PHP: The file for controlling which maps are part of a project. Maps cannot be "created in" a project - they are created, then added to a project. (From the server's POV - the client can of course roll this into one function if it chooses.)

PROJUSERS.PHP: The file for manually adding, removing, and editing user levels within a project.

REGISTER.PHP: New users come here to register.

REMOVE.PHP: The file for removing a map (deprecated but still available) and removing things from a map.

REMOVE_MAP.PHP: A file which allows removal of multiple maps.

SEARCH.PHP: A file for searching maps.

TESTERRORS.PHP: Not really useful any more, but was useful for testing that errorcodes.php worked.

USERINFO.PHP: A file for getting the publicly-available information on a user. E-mail info is not given out publicly to protect users from spam. You may uncomment the relevant line if you want to disregard that protection for your users.

UTILFUNCS.PHP: A collection of utility functions for use in various aspects of this software.

## SAMPLE FILES
Used for testing purposes. Update ID numbers as needed and paste them into XML portions of queries.

# CLIENTSIDE INFORMATION

The client is a Flash application. It uses a pile of XML to handle multilingual capabilities (see translation.xml). This is basically "in-place" translation. A mock-up of more robust translation was placed in translation_schemes.xml, but never implemented because it was not necessary.

Message Arun ("arunkumarchithanar" on Github) if you have questions regarding any part of the client-side code.