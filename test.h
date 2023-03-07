#include <stdio.h>
typedef int typeKey;
typedef int typeVal;

typedef struct _lsmNode{
  typeKey key;
  typeVal val;
} node;

typedef struct _lsm{
  size_t block_size;//number of nodes in a block
  int k;//tree grows dimension
  int node_size;
  size_t next_empty;
  node *block;
  char* disk1;//file name
  bool sorted;
} lsm;

typedef struct _nodeIndex{
  node *node;
  int index;
} nodei;

