# Importing required modules
from flask import Flask, render_template, request, flash, session

#Importing Package
import sqlalchemy
#Database Utility Class
from sqlalchemy.engine import create_engine
# Provides executable SQL expression construct
from sqlalchemy.sql import text
# sqlalchemy.__version__ 

class PostgresqlDB:
    def __init__(self,user_name,password,host,port,db_name):
        """
        class to implement DDL, DQL and DML commands,
        user_name:- username
        password:- password of the user
        host
        port:- port number
        db_name:- database name
        """
        self.user_name = user_name
        self.password = password
        self.host = host
        self.port = port
        self.db_name = db_name
        self.engine = self.create_db_engine()

    def create_db_engine(self):
        """
        Method to establish a connection to the database, will return an instance of Engine
        which can used to communicate with the database
        """
        try:
            db_uri = f"postgresql+psycopg2://{self.user_name}:{self.password}@{self.host}:{self.port}/{self.db_name}"
            return create_engine(db_uri)
        except Exception as err:
            raise RuntimeError(f'Failed to establish connection -- {err}') from err

    def execute_dql_commands(self,stmnt,values=None):
        """
        DQL - Data Query Language
        SQLAlchemy execute query by default as 

        BEGIN
        ....
        ROLLBACK 

        BEGIN will be added implicitly everytime but if we don't mention commit or rollback explicitly 
        then rollback will be appended at the end.
        We can execute only retrieval query with above transaction block.If we try to insert or update data 
        it will be rolled back.That's why it is necessary to use commit when we are executing 
        Data Manipulation Langiage(DML) or Data Definition Language(DDL) Query.
        """
        try:
            with self.engine.connect() as conn:
                if values is not None:
                    result = conn.execute(text(stmnt),values)
                else:
                    result = conn.execute(text(stmnt))
            return result
        except Exception as err:
            print(f'Failed to execute dql commands -- {err}')
    
    def execute_ddl_and_dml_commands(self,stmnt,values=None):
        """
        Method to execute DDL and DML commands
        here we have followed another approach without using the "with" clause
        """
        connection = self.engine.connect()
        trans = connection.begin()
        try:
            if values is not None:

                result = connection.execute(text(stmnt),values)
            else:
                result = connection.execute(text(stmnt))

            trans.commit()
            connection.close()
            print('Command executed successfully.')
        except Exception as err:
            trans.rollback()
            print(f'Failed to execute ddl and dml commands -- {err}')

#Defining Db Credentials
USER_NAME = 'postgres'
PASSWORD = 'postgres'
PORT = 5432
DATABASE_NAME = 'postgres'
HOST = 'localhost'

#Note - Database should be created before executing below operation
#Initializing SqlAlchemy Postgresql Db Instance
db = PostgresqlDB(user_name=USER_NAME,
                    password=PASSWORD,
                    host=HOST,port=PORT,
                    db_name=DATABASE_NAME)
engine = db.engine

# Database connection
local_server = True
app = Flask(__name__)



# Function to get time in HMS format
def convert_timedelta(duration):
    seconds = duration.seconds
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    seconds = (seconds % 60)
    return hours, minutes, seconds

## ROUTING ##

# Passing endpoints and defining the functions

# HOME PAGE
@app.route('/', methods = ['GET', 'POST'])
def hello_world():
    if request.method == 'POST':
        source = request.form.get('source')
        destination = request.form.get('destination')
        departure_date = request.form.get('departure_date')
        passenger_type = request.form.get('passenger_type')

        # Searching for the required data for user-entered "source" and "destination"
        select_query_stmnt1 = "select * from route where source=:source and destination=:destination;"
        value1 = {'source': source, 'destination': destination}
        result1 = db.execute_dql_commands(select_query_stmnt1, value1)
        route_details = result1.fetchone()

        # If no such data is found
        if route_details is None:
            flash("Oops !! We don't fly there...", "warning")
            return render_template('index.html')
        

        rid = route_details.route_id
        rname = route_details.route_name
        sid = rname.split("-")[0]
        did = rname.split("-")[1]


        select_query_stmnt2 = "select * from schedule where route_id=:route_id;"
        value2 = {'route_id': rid}
        result2 = db.execute_dql_commands(select_query_stmnt2, value2)
        flight_details = result2.fetchone()
        fid = flight_details.flight_id
        price = flight_details.price
        atime = flight_details.arrival_time
        dtime = flight_details.departure_time


        select_query_stmnt3 = "select * from get_flight_duration(:fid, :rid);"
        value3 = {'fid' : fid, 'rid' : rid}
        duration = db.execute_dql_commands(select_query_stmnt3, value3).fetchone()[0]


        select_query_stmnt4 = "select flight.airline_id, airline_name from flight, airline where flight.airline_id = airline.airline_id and flight_id=:flight_id;"
        value4 = {'flight_id' : fid}
        result4 = db.execute_dql_commands(select_query_stmnt4, value4)
        airline_details = result4.fetchone()
        airline_name = airline_details.airline_name
        aid = airline_details.airline_id

        # Showing the price of the flight according to the type of the passenger
        if passenger_type == "regular":
            select_query_stmnt = "select * from get_flight_cost_regular(:schedule_date, :regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])

        elif passenger_type == "student":
            select_query_stmnt = "select * from get_flight_cost_student(:schedule_date,:regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])

        elif passenger_type == "senior_citizen":
            select_query_stmnt = "select * from get_flight_cost_senior(:schedule_date,:regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])

        else:
            select_query_stmnt = "select * from get_flight_cost_armed(:schedule_date,:regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])


        return render_template('search.html', flight_cost=flight_cost, duration=duration, source=source, destination=destination, fid=fid, sid=sid, did=did, airline_name=airline_name, aid=aid, atime=atime, dtime=dtime)

    return render_template('index.html')


# ADMIN PAGE
@app.route('/admin')
def admin():
    return render_template('admin.html')


# USER LOGIN PAGE
@app.route('/user_login', methods = ['GET', 'POST'])
def user_login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        select_query_stmnt = "select * from user_table where email=:email;"
        value = {'email':email}
        result = db.execute_dql_commands(select_query_stmnt, value)

        user = result.fetchone()

        # If the user is already registered
        if user and user.password == password:
            flash("You are now logged in", "primary")
            session['user'] = user.user_id
            return render_template('index.html')
        
        # If the credentials are invalid
        else:
            flash("Invalid credentials", "danger")
            return render_template('user_login.html')

    return render_template('user_login.html')


# SIGN UP PAGE
@app.route('/signup', methods = ['GET', 'POST'])
def signup():
    if request.method == 'POST':
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        email = request.form.get('email')
        password = request.form.get('password')
        contact_number = request.form.get('contact_number')

        select_query_stmnt = "select * from user_table where email=:email;"
        value = {'email':email}
        result = db.execute_dql_commands(select_query_stmnt, value)

        user = result.fetchone()

        # If user making a new account with the same email
        if user:
            flash("Account already linked with the given email. Try with another email", "warning")
            return render_template('signup.html')
        
        # Inserting data in the user table
        single_insert_stmnt = "INSERT INTO user_table (first_name, last_name, password, contact_number, email) \
                            VALUES (:first_name, :last_name, :password, :contact_number, :email);"
        
        value = {'first_name': first_name, 'last_name': last_name, 'password': password, 'contact_number': contact_number, 'email': email}
        db.execute_ddl_and_dml_commands(single_insert_stmnt, value)

        flash("Signup success. You can Login now", "success")

    return render_template('signup.html')


# LOGOUT PAGE
@app.route('/logout')
def logout():
    flash("Logged out", "warning")
    session.pop('user', None)
    return render_template('user_login.html')


# TRANSACTION PAGE
@app.route('/transaction')
def transaction():
    return render_template('transaction.html')


# BOOKING PAGE
@app.route('/book', methods = ['GET', 'POST'])
def book():
    if request.method == 'POST':

        title = request.form.get('title')
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        gender = request.form.get('gender')
        email = request.form.get('email')
        dob = request.form.get('dob')
        contact_number = request.form.get('contact_number')
        identity_card_id = request.form.get('identity_card_id')
        passenger_type = request.form.get('passenger_type')

        # Inserting data into the Passenger table
        single_insert_stmnt = "INSERT INTO Passenger (title, first_name, last_name, gender, contact_number, email, dob, identity_card_id, passenger_type) \
                            VALUES (:title, :first_name, :last_name, :gender, :contact_number, :email, :dob, :identity_card_id, :passenger_type);"
        
        value = {'title': title, 'first_name': first_name, 'last_name': last_name, 'gender': gender, 'contact_number': contact_number, 'email': email, 'dob': dob, 'identity_card_id' : identity_card_id, 'passenger_type' : passenger_type}
        db.execute_ddl_and_dml_commands(single_insert_stmnt, value)

        return render_template('transaction.html')
    
    if 'user' in session:
        return render_template('book.html')
    
    flash("Please login first!!", "danger")
    return render_template('user_login.html')


# SEARCH PAGE
@app.route('/search', methods = ['GET', 'POST'])
def search():
    if request.method == 'POST':
        source = request.form.get('source')
        destination = request.form.get('destination')
        departure_date = request.form.get('departure_date')
        passenger_type = request.form.get('passenger_type')

        select_query_stmnt1 = "select * from route where source=:source and destination=:destination;"
        value1 = {'source': source, 'destination': destination}
        result1 = db.execute_dql_commands(select_query_stmnt1, value1)
        route_details = result1.fetchone()

        # If there are no flights with given "source" and "destination"
        if route_details is None:
            flash("Oops !! We don't fly there...", "warning")
            return render_template('index.html')
        
        rid = route_details.route_id
        rname = route_details.route_name
        sid = rname.split("-")[0]
        did = rname.split("-")[1]


        select_query_stmnt2 = "select * from schedule where route_id=:route_id;"
        value2 = {'route_id': rid}
        result2 = db.execute_dql_commands(select_query_stmnt2, value2)
        flight_details = result2.fetchone()
        fid = flight_details.flight_id
        price = flight_details.price
        atime = flight_details.arrival_time
        dtime = flight_details.departure_time


        select_query_stmnt3 = "select * from get_flight_duration(:fid, :rid);"
        value3 = {'fid' : fid, 'rid' : rid}
        duration = db.execute_dql_commands(select_query_stmnt3, value3).fetchone()[0]


        select_query_stmnt4 = "select flight.airline_id, airline_name from flight, airline where flight.airline_id = airline.airline_id and flight_id=:flight_id;"
        value4 = {'flight_id' : fid}
        result4 = db.execute_dql_commands(select_query_stmnt4, value4)
        airline_details = result4.fetchone()
        airline_name = airline_details.airline_name
        aid = airline_details.airline_id

        # Showing the price of the flight according to the type of the passenger
        if passenger_type == "regular":
            select_query_stmnt = "select * from get_flight_cost_regular(:schedule_date, :regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])

        elif passenger_type == "student":
            select_query_stmnt = "select * from get_flight_cost_student(:schedule_date,:regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])

        elif passenger_type == "senior_citizen":
            select_query_stmnt = "select * from get_flight_cost_senior(:schedule_date,:regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])

        else:
            select_query_stmnt = "select * from get_flight_cost_armed(:schedule_date,:regular_price);"
            value = {'schedule_date': departure_date, 'regular_price' : price}
            flight_cost = round(db.execute_dql_commands(select_query_stmnt, value).fetchone()[0])


        return render_template('search.html', flight_cost=flight_cost, duration=duration, source=source, destination=destination, fid=fid, sid=sid, did=did, airline_name=airline_name, aid=aid, atime=atime, dtime=dtime)

    return render_template('search.html')

# ADMIN LOGIN PAGE
@app.route('/login_admin', methods = ['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        if email=="admin" and password == "admin":
            flash("You are now logged in", "primary")
            return render_template('admin.html')
        else:
            flash("Invalid credentials", "danger")
            return render_template('login_admin.html')

    return render_template('login_admin.html')


if __name__ == '__main__':
    app.secret_key = "niharika"
    app.run(debug=True)