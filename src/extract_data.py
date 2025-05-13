import pandas as pd
import os
from pathlib import Path

def read_csvfile(file_path):
    """
    Read a CSV file and return a pandas DataFrame.
    
    Args:
        file_path (str): Path to the CSV file
    
    Returns:
        DataFrame or None: DataFrame if successful, None if failed
    """
    try:
        df = pd.read_csv(file_path)
        print(f"Successfully read {file_path} with {len(df)} rows and {len(df.columns)} columns")
        return df
    except Exception as e:
        print(f"Error reading file {file_path}: {e}")
        return None

def extract_all_files(data_dir):
    """
    Extract data from all CSV files in the specified directory.
    
    Args:
        data_dir (str): Directory containing the CSV files
    
    Returns:
        dict: Dictionary containing DataFrames with table names as keys
    """
    data_dir = Path(data_dir)
    dataframes = {}
    
    # Mapping of CSV files to table names
    file_to_table_map = {
        'olist_customers_dataset.csv': 'customers',
        'olist_order_items_dataset.csv': 'order_items',
        'olist_order_payments_dataset.csv': 'order_payments',
        'olist_order_reviews_dataset.csv': 'order_reviews',
        'olist_orders_dataset.csv': 'orders',
        'olist_products_dataset.csv': 'products',
        'olist_sellers_dataset.csv': 'sellers',
        'product_category_name_translation.csv': 'product_category_translation',
        'olist_geolocation_dataset.csv': 'geolocation'
    }
    
    # Extract each file
    for file_name, table_name in file_to_table_map.items():
        file_path = data_dir / file_name
        if file_path.exists():
            df = read_csvfile(file_path)
            if df is not None:
                dataframes[table_name] = df
        else:
            print(f"File {file_path} not found")
    
    return dataframes

if __name__ == "__main__":
    # Example usage
    PROJECT_ROOT = Path(__file__).resolve().parent.parent # Goes up two levels: src -> project_root
    data_directory = PROJECT_ROOT / "data" / "raw" / "archive (1)"

    print(f"Testing extract_data.py with data_directory: {data_directory}") # For verification
    dataframes = extract_all_files(data_directory)
    
    # Print available tables
    print("Available tables:", list(dataframes.keys()))
    
    # Print sample data from customers table if available
    if 'customers' in dataframes:
        print("\nCustomers table sample:")
        print(dataframes['customers'].head())
