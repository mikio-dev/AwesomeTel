import pandas as pd


def table_summary(table_schema, table_name, engine):

    # Get columns
    sql = f"""
    SELECT * 
    FROM information_schema.columns
    WHERE table_schema = '{table_schema}'
      AND table_name = '{table_name}'
    ORDER BY ordinal_position;
    """
    result = pd.read_sql(sql, engine)
    columns = result["column_name"].tolist()
    data_types = result["data_type"].tolist()

    output = []
    # Get column summary
    for column, data_type in zip(columns, data_types):
        sql = f"""
        SELECT '{column}' column_name,
               '{data_type}' data_type,
               COUNT(*) total_count,
               COUNT(distinct {column}) unique_count,
               COUNT(distinct {column}) = count(*) as is_unique,
        """
        if data_type == "boolean":
            sql += f"""
               NULL as min_value,
               NULL as max_value,
               COUNT(CASE WHEN {column} = TRUE THEN 1 END) as true_count,
               COUNT(CASE WHEN {column} = FALSE THEN 1 END) as false_count,
            """
        else:
            sql += f"""
               min({column}) as min_value,
               max({column}) as max_value,
               NULL as true_count,
               NULL as false_count,
            """
        sql += f"""
               COUNT(CASE WHEN {column} is null THEN 1 END) as null_count,
               COUNT(CASE WHEN {column}::varchar = '' THEN 1 END) as empty_count,
               CASE WHEN COUNT(distinct {column}) < 15
                    THEN array_agg(distinct {column})
                    ELSE NULL
               END as unique_values
        FROM {table_schema}.{table_name}
        """
        result = pd.read_sql(sql, engine)
        output.append(result)

    return pd.concat(output, axis=0).reset_index(drop=True)
