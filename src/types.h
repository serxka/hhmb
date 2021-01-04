#ifndef _HEADER_TYPES
#define _HEADER_TYPES 1

#include <stdint.h>

#define static_assert _Static_assert
#define NULL ((void*)0)

// Unsinged Integers
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
// Signed Integers
typedef int8_t s8;
typedef int16_t s16;
typedef int32_t s32;
typedef int64_t s64;

typedef _Bool bool;
enum {
	false = 0,
	true = 1
};

#endif // _HEADER_TYPES

