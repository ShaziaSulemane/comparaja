# DataBase

Made with MySQL (https://www.mysql.com/downloads/).
To create database use  `\database\comparaja.sql`, file includes  `inserts ` and  `routines `.
The answer to the second question on the challenge is on  `filtro.sql `, and the 
queries are on  `script.sql ` where the answer to the first question on the
challenge is the first query.

To run the database used the MySQL benchwork, and to run locally installed 
XAMMP (https://www.apachefriends.org/download.html).


# The Python Code

To run the API, install the packages on `requirements.txt` to create
a Flask APP. Install ` pip install flask_mysqldb`. To access the product information about a certain provider
write `flask run` on the terminal. If it does not work write on the
terminal ` set FLASK_APP=test.py`,  `$env:FLASK_APP = "test.py"`before running.

```
pip install flask_mysqldb
set FLASK_APP=test.py
$env:FLASK_APP = "test.py

flask run
```
 `/getproviderproductsinfo` returns the data
about each product from the provider given in the `\form`.

`/getproviderproducts` returns only the product id and vertical name
about each product from the provider given in the `\form`.

# The FrontEnd

Run `/form` to show the form where the user introduces the name of the 
provider to search for their products. The frontend was made with 
bootstrap. 

The form.html file is the base file. 
The table.html file was a test and presents de data from the database
in a table format.
The card.html file shows the data in card form just like asked in
question 1 of the "Build Front-end for results" page section.
