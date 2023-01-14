#/bin/bash -e

python3 TB_FIFO_Rx.py | python3 TB_FIFO_Tx.py
