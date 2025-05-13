import os 
from db_utils import get_db_connection
from extract_data import extract_all_files
from load_data import load_all_tables

def main():
    """
    Main ETL pipeline function.
    Extracts data from CSV files, loads them to the database,
    and reports the results.
    """
    # Configuration
    PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    data_dir = os.path.join(PROJECT_ROOT, "data", "raw", "archive (1)")
    
    # Step 1: Establish database connection
    print("Establishing database connection...")
    engine = get_db_connection()
    
    # Step 2: Extract data from files
    print("Starting data extraction...")
    dataframes = extract_all_files(data_dir)
    print(f"Extracted {len(dataframes)} tables")
    
    # Step 3: Load data to database
    print("Starting data loading...")
    successfully_loaded = load_all_tables(engine, dataframes, schema='bronze')
    print(f"Successfully loaded {len(successfully_loaded)} tables")
    
    # Step 4: Report results
    print("\n" + "="*50)
    print("ETL Process Summary")
    print("="*50)
    print(f"Total tables extracted: {len(dataframes)}")
    print(f"Successfully loaded tables: {len(successfully_loaded)}")
    
    if successfully_loaded:
        print("\nSuccessfully loaded tables:")
        for table in successfully_loaded:
            print(f"  - {table}")
    
    failed_tables = set(dataframes.keys()) - set(successfully_loaded)
    if failed_tables:
        print("\nFailed to load tables:")
        for table in failed_tables:
            print(f"  - {table}")
    
    print("="*50)
    print("ETL process finished.")

if __name__ == "__main__":
    main()
