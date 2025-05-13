# Olist E-commerce Data ETL and Analysis Project

[![GitHub repository](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/anime7/olist_ecommerce_analysis)

## Description

This project implements an ETL (Extract, Transform, Load) pipeline to process the Olist E-commerce dataset. It extracts data from raw CSV files, loads it into a PostgreSQL database with a well-defined schema, and prepares data for analysis through SQL views. Processed views can then be exported to CSV files. The project is structured for maintainability and version control with Git and GitHub.

## Project Objective

To refine an initial local data project into a well-structured Python application. This involves:
* Extracting data from multiple Olist CSV files.
* Loading the structured data into a PostgreSQL database.
* Organizing SQL scripts for schema creation, table creation, constraints, and analytical views.
* Providing a main Python ETL pipeline script to orchestrate the data loading process.
* Enabling export of analytical views to CSV files.

## Project Structure

olist_ecommerce_analysis/
├── config/                     # (Currently empty) For future configuration files
├── data/
│   ├── raw/archive (1)/        # Original Olist CSV data files reside here
│   └── processed/              # Target directory for CSV exports from views
├── notebooks/                  # Original Jupyter notebooks (for reference/exploration)
│   ├── db_connection.ipynb
│   ├── extract.ipynb
│   ├── load.ipynb
│   └── main.ipynb
├── sql/                        # SQL scripts for database setup and data export
│   ├── 00_create_schemas.sql
│   ├── 01_create_bronze_tables.sql
│   ├── 02_apply_constraints.sql
│   ├── 03_create_analytical_views.sql
│   └── 04_misc_data_checks_and_exports.sql
├── src/                        # Source Python scripts for the ETL pipeline
│   ├── init.py
│   ├── db_utils.py             # Utilities for database connection
│   ├── etl_pipeline.py         # Main script to run the ETL process
│   ├── extract_data.py         # Functions for extracting data from CSVs
│   └── load_data.py            # Functions for loading data into PostgreSQL
├── .env                        # For database credentials (MUST BE CREATED MANUALLY and is GIT-IGNORED)
├── .gitignore                  # Specifies intentionally untracked files for Git
└── requirements.txt            # Python package dependencies


## Prerequisites

Before you begin, ensure you have the following installed:
* Python (version 3.8 or higher recommended)
* Git
* PostgreSQL (ensure the service is running and you can connect to it)
* A PostgreSQL client tool (e.g., `psql` CLI, pgAdmin, DBeaver) for running SQL scripts.

## Setup and Installation

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/anime7/olist_ecommerce_analysis.git](https://github.com/anime7/olist_ecommerce_analysis.git)
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
    Create a `.env` file in the root directory of the project (`olist_ecommerce_analysis/.env`). This file will store your database connection details. Add the following content, replacing placeholders with your actual PostgreSQL credentials:
    ```env
    DB_USER=your_postgres_user
    DB_PASSWORD=your_postgres_password
    DB_HOST=localhost
    DB_PORT=5432
    DB_NAME=your_olist_database_name
    ```
    **Note:**
    * Ensure `your_olist_database_name` is an existing database in your PostgreSQL instance, or create it before proceeding.
    * The `DB_USER` must have permissions to create schemas and tables, and load data into this database.
    * The `.env` file is listed in `.gitignore` and should NOT be committed to version control.

5.  **Place Raw Data Files**
    Download the Olist E-commerce dataset CSV files and place them into the `data/raw/archive (1)/` directory. The `src/extract_data.py` script expects the following files:
    * `olist_customers_dataset.csv`
    * `olist_geolocation_dataset.csv`
    * `olist_order_items_dataset.csv`
    * `olist_order_payments_dataset.csv`
    * `olist_order_reviews_dataset.csv`
    * `olist_orders_dataset.csv`
    * `olist_products_dataset.csv`
    * `olist_sellers_dataset.csv`
    * `product_category_name_translation.csv`
    *(Note: One of these files, `olist_geolocation_dataset.csv`, is over 50MB. While it has been successfully pushed to GitHub, be aware that GitHub may recommend Git LFS for handling multiple or larger files of this size.)*

## Running the Project

Follow these steps in order:

1.  **Set Up Database Structure (SQL DDL Scripts)**
    Using your preferred PostgreSQL tool (e.g., `psql`), connect to your target database (`DB_NAME` specified in `.env`) and execute the following SQL scripts from the `sql/` directory in sequence:
    1.  `00_create_schemas.sql` (Creates `bronze`, `silver`, `gold` schemas)
    2.  `01_create_bronze_tables.sql` (Creates tables in the `bronze` schema)
    3.  `02_apply_constraints.sql` (Applies primary/foreign keys to bronze tables)
    4.  `03_create_analytical_views.sql` (Creates analytical views in the `bronze` schema like `order_performance_summery`, `product_category_performance`, etc.)

2.  **Run the Python ETL Pipeline**
    This script populates the tables created in the previous step. Ensure your virtual environment is active and you are in the project's root directory.
    ```bash
    python src/etl_pipeline.py
    ```
    The script will:
    * Connect to the database using credentials from `.env`.
    * Extract data from CSVs in `data/raw/archive (1)/`.
    * Load data into the `bronze` schema tables.
    * Print a summary upon completion.

3.  **Export Analytical Views to CSV (Manual Step)**
    To generate CSV files from the analytical views (created by `03_create_analytical_views.sql`) into the `data/processed/` directory:
    * Ensure the `data/processed/` directory exists in your project structure. If not, create it.
    * Open `psql` (or your preferred SQL tool that can execute `\copy` commands if not `psql`).
    * Connect to your database.
    * **Important:** Ensure your `psql` session's current working directory is the project root (`olist_ecommerce_analysis/`). The `\copy` commands in the script use relative paths like `data/processed/filename.csv`.
    * Execute the export script:
        ```pSQL
        \i sql/04_misc_data_checks_and_exports.sql
        ```
        This script also contains some `SELECT` statements for quick data checks. The relevant `\copy` commands will export the views to the `data/processed/` directory.

## SQL Scripts Overview

* `00_create_schemas.sql`: Creates the `bronze`, `silver`, and `gold` schemas.
* `01_create_bronze_tables.sql`: Defines table structures for raw data in the `bronze` schema.
* `02_apply_constraints.sql`: Adds primary and foreign key constraints to `bronze` tables.
* `03_create_analytical_views.sql`: Creates analytical views (e.g., `order_performance_summery`, `customer_geographic_analysis`) in the `bronze` schema.
* `04_misc_data_checks_and_exports.sql`: Contains `SELECT` statements for data validation and `\copy` commands to export the analytical views to CSV files in `data/processed/` (requires manual execution from the project root via `psql`).

## Future Enhancements (Ideas)

* Implement more sophisticated data cleaning and transformation logic (potentially in a `silver` layer).
* Add comprehensive logging throughout the ETL pipeline.
* Develop automated data quality checks and reporting.
* Integrate unit and integration tests.
* Containerize the application using Docker for easier deployment and environment consistency.
* Explore using Git LFS if more large data files are added.

