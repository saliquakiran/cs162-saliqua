# Write-Ahead Logging (WAL)

Write-Ahead Logging (WAL) is a method used to ensure database reliability by recording changes in a separate log before they are applied to the actual database. This approach makes sure that in case of an interruption (e.g., a power outage or system crash), the database can revert to its last consistent state by using the information in the log. Let’s walk through a simple example to understand how this process works and how it helps maintain database consistency during unexpected events.

## Example 

Imagine a small database keeping track of bank balances for two accounts: Account A and Account B. Each account starts with a balance of $1000. A transaction is initiated to transfer $200 from Account A to Account B.

### Step-by-Step Process Using WAL

1. **Start Transaction**: A transaction is initiated to transfer $200 from Account A to Account B.
   
2. **Log the Changes (Write-Ahead Log)**:
   - The WAL records that $200 is to be deducted from Account A. This entry is added to the WAL file:
     - `WAL: DEBIT $200 FROM Account A (New balance: $800)`
   - Next, the WAL logs that $200 is to be credited to Account B:
     - `WAL: CREDIT $200 TO Account B (New balance: $1200)`

3. **Apply the Changes**:
   - After the changes are recorded in the WAL, the system begins to apply the changes to the database.
   - It first updates Account A’s balance to $800 and then updates Account B’s balance to $1200.

4. **Commit the Transaction**:
   - Once both updates are applied, a commit entry is appended to the WAL, indicating that the transaction has been successfully completed:
     - `WAL: COMMIT`

5. **Checkpointing**:
   - During checkpointing, changes from the WAL are written back to the main database file. The WAL entries are cleared after successful checkpointing, reducing the size of the log.

### Handling Interruption

Now, let’s see what happens if an interruption, such as a power failure, occurs during the update:

- **Interruption After Logging but Before Applying Changes**:
   - Suppose the system crashes right after logging the changes in the WAL but before updating the database. When the system restarts, it checks the WAL. It sees that the `DEBIT` and `CREDIT` actions were logged but not applied.
   - Since no `COMMIT` record is found in the WAL, the database discards the logged changes and reverts to its last consistent state (Account A = $1000, Account B = $1000).
   - This ensures that partially applied changes do not corrupt the database.

- **Interruption After Applying Changes but Before Commit**:
   - Suppose the system crashes after updating Account A’s balance to $800 but before crediting Account B. On restart, the system checks the WAL and sees that the transaction was not committed.
   - It uses the WAL to roll back the changes to Account A, restoring its balance to $1000.
   - Again, the database returns to a consistent state (Account A = $1000, Account B = $1000).

- **Interruption After Commit**:
   - If the system crashes after the commit record is written to the WAL, the changes are safe.
   - Upon restarting, the system sees the commit record in the WAL and ensures that the changes are applied, resulting in Account A having $800 and Account B having $1200.
   - As the changes were successfully committed, the database reflects the new balances.

Thus, write-Ahead Logging allows the database to recover from interruptions by ensuring that no changes are made directly to the database until they are safely logged. The database only commits the changes after all operations in a transaction are logged, allowing it to revert to a consistent state using the WAL if a failure occurs. This process ensures that transactions remain atomic (all or nothing), even when unexpected events happen, thus preserving data integrity and consistency.
