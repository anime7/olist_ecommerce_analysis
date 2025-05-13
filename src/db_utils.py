import os 
from dotenv import load_dotenv
from sqlalchemy import create_engine

# Load environment variables
load_dotenv()

def get_db_connection():
    """
    Establish a database connection using environment variables.
    
    Returns:
        engine: SQLAlchemy engine object for database connection
    """
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    db = os.getenv("DB_NAME")
    port = os.getenv("DB_PORT")
   
    connection_string = f'postgresql://{user}:{password}@{host}:{port}/{db}'
    print("Connection String:", connection_string)
    engine = create_engine(connection_string)
    return engine

if __name__ == "__main__":
    # Test the connection when running the script directly
    engine = get_db_connection()
    try:
        with engine.connect() as conn:
            print("Connection String:", conn)
            print("Connection successful")
    except Exception as e:
        print("Connection failed:", e)
