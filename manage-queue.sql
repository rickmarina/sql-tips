
-- Allow manage a queue of elements taken from a table 
-- (e.g. a queue of pending tasks)
-- retrieving the next element from the queue or N elementos (top(N))

;WITH cte AS (
  SELECT TOP(1) q.status, TASK_ID, id_trade, id_item
  FROM TR_UNBLOCKING_TASKS q WITH (ROWLOCK, READPAST, UPDLOCK)
  WHERE status = 0
  ORDER BY fecha
 )
UPDATE cte
  SET status = 1
OUTPUT
  INSERTED.TASK_ID
