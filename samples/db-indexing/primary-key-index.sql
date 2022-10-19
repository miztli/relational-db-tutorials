-- Create table: index_demo

CREATE TABLE index_demo (
    name VARCHAR(20) NOT NULL,
    age INT,
    pan_no VARCHAR(20),
    phone_no VARCHAR(20)
);

-- verify engine
SHOW TABLE STATUS WHERE NAME = 'index_demo';

-- list indexes
SHOW INDEX from index_demo;

-- row inserts
INSERT INTO index_demo VALUES('Miztli', 32, '123456789', '5519344556');
INSERT INTO index_demo VALUES('Leticia', 32, '23433556', '5543344222');
INSERT INTO index_demo VALUES('Mariana', 32, '32546576', '5546677889');
INSERT INTO index_demo VALUES('Gabriela', 32, '987654321', '5543322222');
INSERT INTO index_demo VALUES('Azul', 32, '353455623', '5578876554');
SELECT * FROM index_demo;

-- explain query without index
/* EXPLAIN: shows how the query engine plans to execute the query. 
 * rows: returns 5. 
 * possible_keys: represents what all available indices are there which can be used in this query. 
 * key column represents which index is actually going to be used out of all possible indices in this query.
 */
EXPLAIN SELECT * FROM index_demo WHERE phone_no = '5546677889';;


/*
 * As of now we haven't defined a primary key, however InnoDB implicitly creates one for us by design,
 * once you create a primary key later on for that table, InnoDB deletes the previously auto defined 
 * primary key.
 * Here we see that MySQL has defined a composite index on DB_ROW_ID , DB_TRX_ID, DB_ROLL_PTR, name, age, pan_no and phone_no. 
 * In the absence of a user defined primary key.
 */
SHOW EXTENDED INDEX from index_demo;

-- Create an index
-- rollback: ALTER TABLE index_demo DROP PRIMARY KEY;
/*
 * Non_unique: If the value is 1, the index is not unique, if the value is 0, the index is unique.
 * Key_name: The name of the index created. The name of the primary index is always PRIMARY in MySQL, irrespective of if you have provided any index name or not while creating the index.
 * Seq_in_index: The sequence number of the column in the index. If multiple columns are part of the index, the sequence number will be assigned based on how the columns were ordered during the index creation time. Sequence number starts from 1.
 * Collation: How the column is sorted in the index. A means ascending, D means descending, NULL means not sorted.
 * Cardinality: The estimated number of unique values in the index. More cardinality means higher chances that the query optimizer will pick the index for queries.
 * Sub_part : The index prefix. It is NULL if the entire column is indexed. Otherwise, it shows the number of indexed bytes in case the column is partially indexed.
 * Packed: Indicates how the key is packed; NULL if it is not.
 * Null: YES if the column may contain NULL values and blank if it does not.
 * Index_type: Indicates which indexing data structure is used for this index. Some possible candidates are — BTREE, HASH, RTREE, or FULLTEXT.
 * Comment: The information about the index not described in its own column.
 * Index_comment: The comment for the index specified when you created the index with the COMMENT attribute.
*/
ALTER TABLE index_demo ADD PRIMARY KEY (phone_no);
SHOW INDEXES FROM index_demo;

/* notice that the rows column has returned 1 only, the possible_keys & key both returns PRIMARY
 * So it essentially means that using the primary index named as PRIMARY (the name is auto assigned when you create the primary key), 
 * the query optimizer just goes directly to the record & fetches it.
 */
EXPLAIN SELECT * FROM index_demo WHERE phone_no = '5546677889';


