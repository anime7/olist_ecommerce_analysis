import pandas as pd
from sqlalchemy import inspect
from sqlalchemy import text
import os
import pathlib
from db_utils import get_db_connection
from extract_data import extract_all_files

def load_dataframe_to_table(engine, dataframe, table_name, schema='bronze', if_exists='append'):
    """
    Load a DataFrame to a database table.
    
    Args:
        engine: SQLAlchemy engine object
        dataframe: pandas DataFrame to load
        table_name (str): Name of the target table
        schema (str): Database schema (default: 'bronze')
        if_exists (str): How to behave if table exists (default: 'append')
    
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        # Load data to database
        dataframe.to_sql(
            name=table_name,
            con=engine,
            schema=schema,
            if_exists='append',
            index=False,
            chunksize=1000
        )
        
        # Get count of records in the table
        with engine.connect() as conn:
            query = text(f"SELECT COUNT(*) FROM {schema}.{table_name}")
            result = conn.execute(query)
            count = result.scalar()
        
        print(f"Successfully loaded {count} rows into {schema}.{table_name}")
        return True
    except Exception as e:
        print(f"Error while loading data into {schema}.{table_name}: {e}")
        return False

def load_all_tables(engine, dataframes, schema='bronze'):
    """
    Load all DataFrames to database tables.
    
    Args:
        engine: SQLAlchemy engine object
        dataframes (dict): Dictionary of DataFrames with table names as keys
        schema (str): Database schema (default: 'bronze')
    
    Returns:
        list: List of successfully loaded table names
    """
    successfully_loaded = []
    
    # Create schema if it doesn't exist
    with engine.connect() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema}"))
        conn.commit()
    
    # Load each table
    for table_name, df in dataframes.items():
        success = load_dataframe_to_table(engine, df, table_name, schema)
        if success:
            successfully_loaded.append(table_name)
    
    return successfully_loaded

if __name__ == "__main__":
    from db_utils import get_db_connection     
    from extract_data import extract_all_files
    
    # Example usage
    PROJECT_ROOT = pathlib.Path(__file__).resolve().parent.parent
    data_dir = PROJECT_ROOT / "data" / "raw" / "archive (1)"
    
    # Get database connection
    engine = get_db_connection()
    
    # Extract data
    dataframes = extract_all_files(data_dir)
    
    # Load data
    if dataframes:
        loaded_tables = load_all_tables(engine, dataframes)
        print(f"Successfully loaded tables: {loaded_tables}")
    else:
        print("No data to load")
