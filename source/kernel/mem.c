#include <stdint.h>

void memory_copy(uint16_t* source, uint16_t* dest, int no_bytes)
{
  int i;
  for (i=0; i<no_bytes; i++) {
    *(dest + i) = *(source + i);
  }
}
