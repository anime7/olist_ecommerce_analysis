# Olist E-commerce Data ETL and Analysis Project

## Description

This project implements an ETL (Extract, Transform, Load) pipeline to process the Olist E-commerce dataset. It extracts data from raw CSV files, loads it into a PostgreSQL database, and prepares it for further analysis. The project is structured to be maintainable and suitable for version control with Git and GitHub.

## Project Objective

To refine an initial local data project into a well-structured Python application. This involves:
* Extracting data from multiple Olist CSV files.
* Loading the structured data into a PostgreSQL database.
* Organizing SQL scripts for schema creation, table creation, constraints, and analytical views.
* Providing a main ETL pipeline script to orchestrate the process.

## Project Structure

olist_ecommerce_analysis/
├── config/                     # (Currently empty) For future configuration files
├── data/
│   ├── raw/archive (1)/        # Place original Olist CSV data files here
│   └── processed/              # For future processed data or exports
├── notebooks/                  # Original Jupyter notebooks for reference
│   ├── db_connection.ipynb
│   ├── extract.ipynb
│   ├── load.ipynb
│   └── main.ipynb
├── sql/                        # SQL scripts for database setup
│   ├── 00_create_schemas.sql
│   ├── 01_create_bronze_tables.sql
│   ├── 02_apply_constraints.sql
│   ├── 03_create_analytical_views.sql
│   └── 04_misc_data_checks_and_exports.sql
├── src/                        # Source Python scripts for the ETL pipeline
│   ├── __init__.py
│   ├── db_utils.py             # Utilities for database connection
│   ├── etl_pipeline.py         # Main script to run the ETL process
│   ├── extract_data.py         # Functions for extracting data from CSVs
│   └── load_data.py            # Functions for loading data into PostgreSQL
├── .env                        # For database credentials and other environment variables (MUST BE CREATED MANUALLY)
├── .gitignore                  # Specifies intentionally untracked files that Git should ignore
└── requirements.txt            # Python package dependencies


## Prerequisites

Before you begin, ensure you have the following installed:
* Python (version 3.8 or higher recommended)
* PostgreSQL (ensure the service is running)
* A tool to interact with PostgreSQL (e.g., `psql`, pgAdmin, DBeaver)

## Setup and Installation

1.  **Clone the Repository (Example)**
    ```bash
    git clone <your-repository-url>
    cd olist_ecommerce_analysis
    ```

2.  **Create and Activate a Virtual Environment**
    It's highly recommended to use a virtual environment:
    ```bash
    python -m venv venv
    ```
    Activate it:
    * On Windows (Git Bash or similar):
        ```bash
        source venv/Scripts/activate
        ```
    * On Windows (Command Prompt/PowerShell):
        ```bash
        .\venv\Scripts\activate
        ```
    * On macOS/Linux:
        ```bash
        source venv/bin/activate
        ```

3.  **Install Dependencies**
    With the virtual environment activated, install the required Python packages:
    ```bash
    pip install -r requirements.txt
    ```

4.  **Set Up Environment Variables (`.env` file)**
    Create a `.env` file in the root directory of the project (`olist_ecommerce_analysis/.env`). This file will store your database connection details. Add the following content to it, replacing the placeholder values with your actual PostgreSQL credentials:
    ```env
    DB_USER=your_postgres_user
    DB_PASSWORD=your_postgres_password
    DB_HOST=localhost
    DB_PORT=5432
    DB_NAME=your_olist_database_name
    ```
    **Note:** Ensure `your_olist_database_name` is an existing database in your PostgreSQL instance, or create it before running the SQL scripts. The `DB_USER` should have permissions to create schemas and tables in this database.

5.  **Place Raw Data Files**
    Download the Olist E-commerce dataset CSV files and place them into the `data/raw/archive (1)/` directory. The `extract_data.py` script expects the following files to be present in that location:
    * `olist_customers_dataset.csv`
    * `olist_geolocation_dataset.csv`
    * `olist_order_items_dataset.csv`
    * `olist_order_payments_dataset.csv`
    * `olist_order_reviews_dataset.csv`
    * `olist_orders_dataset.csv`
    * `olist_products_dataset.csv`
    * `olist_sellers_dataset.csv`
    * `product_category_name_translation.csv`

6.  **Set Up the Database Schema and Tables**
    Before running the Python ETL pipeline for the first time, you need to set up the database structure using the provided SQL scripts. Execute the scripts in the `sql/` directory in the following order using your preferred PostgreSQL tool (e.g., psql, pgAdmin):
    1.  `00_create_schemas.sql` (Creates the `bronze` and `silver` schemas if they don't exist)
    2.  `01_create_bronze_tables.sql` (Creates the tables in the `bronze` schema)
    3.  `02_apply_constraints.sql` (Applies primary keys, foreign keys, and other constraints to the bronze tables)
    4.  `03_create_analytical_views.sql` (Creates views in the `silver` schema for analytical purposes)
    5.  `04_misc_data_checks_and_exports.sql` (Contains miscellaneous checks; review before running)

    The `load_data.py` script will attempt to create the target schema (e.g., `bronze`) if it doesn't exist, but it's good practice to run `00_create_schemas.sql` first. The table structures and constraints must be created by the SQL scripts before data loading.

## Running the ETL Pipeline

Once the setup is complete (virtual environment activated, dependencies installed, `.env` file configured, raw data in place, and database schemas/tables created via SQL scripts), you can run the main ETL pipeline.

Navigate to the `src/` directory and execute the `etl_pipeline.py` script:
```bash
cd src
python etl_pipeline.py
This script will:

Establish a database connection using credentials from the .env file.
Extract data from the CSV files located in data/raw/archive (1)/.
Load the extracted data into the corresponding tables in the bronze schema of your PostgreSQL database.
Print a summary of the ETL process.
SQL Scripts
The sql/ directory contains scripts to manage the database structure:

00_create_schemas.sql: Creates necessary schemas (e.g., bronze, silver).
01_create_bronze_tables.sql: Defines the schema for the raw data tables in the bronze layer.
02_apply_constraints.sql: Sets up primary keys, foreign keys, and other constraints to ensure data integrity.
03_create_analytical_views.sql: Creates denormalized views or aggregated tables in a silver schema, suitable for easier querying and analysis.
04_misc_data_checks_and_exports.sql: Includes various data validation queries and example export commands (use as needed).
Future Enhancements (Optional Ideas)
Implement more sophisticated data cleaning and transformation logic.
Add logging throughout the ETL pipeline.
Develop data quality checks and reporting.
Integrate automated testing.
Containerize the application using Docker.

