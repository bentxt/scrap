import sys
from sqids import Sqids

sqids = Sqids(alphabet="abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789")

print(sqids.encode(sys.argv[0]))

